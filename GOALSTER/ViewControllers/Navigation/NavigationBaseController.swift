//
//  NavigationBaseController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import AppTrackingTransparency
import FBSDKCoreKit

class NavigationMenuBaseController: UITabBarController {
    lazy var disposeBag = DisposeBag()
    lazy var tabItems: [TabItem] = [.feed, .goals, .calendar, .knowledge, .profile]
    
    var customTabBar: TabNavigationMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        loadTabBar()
        bind()
        
        if let notification = AppShared.sharedInstance.notification {
            openNotification(notification: notification)
        }
        
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = false
        ModuleUserDefaults.setIsInitial(true)
        
        TrackerManager.setAdvertiserTracking()
        TrackerManager.setAdvancedMatching()
    }
    
    func bind() {
        AppShared.sharedInstance.notificationSubject.subscribe(onNext: { type in
            DispatchQueue.main.async {
                self.openNotification(notification: type)
            }
        }).disposed(by: disposeBag)
        AppShared.sharedInstance.profileSubject.subscribe(onNext: { object in
            DispatchQueue.main.async {
                if object == nil {
                    self.navigationController?.popViewController(animated: true)
                    AppShared.sharedInstance.navigationController?.pushViewController(NeedProfileViewController(), animated: true)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func loadTabBar() {
        self.setupCustomTabBar(tabItems) { (controllers) in
            self.viewControllers = controllers
        }
        
        self.selectedIndex = 0
    }
    
    private func setupCustomTabBar(_ items: [TabItem], completion: @escaping ([UIViewController]) -> Void){
        let frame = tabBar.frame
        var controllers = [UIViewController]()
        
        tabBar.isHidden = true
        
        customTabBar = TabNavigationMenu(menuItems: items, frame: frame)
        customTabBar.itemTapped = self.changeTab
        
        customTabBar.layer.shadowRadius = 5
        customTabBar.layer.shadowColor = UIColor.black.cgColor
        customTabBar.layer.shadowOpacity = 0.15
        
        view.addSubview(customTabBar)
        
        customTabBar.snp.makeConstraints({
            $0.left.right.bottom.width.equalTo(tabBar)
            $0.height.equalTo(StaticSize.tabBarHeight)
        })
        
        for i in 0 ..< items.count {
            controllers.append(items[i].viewController)
        }
        
        view.layoutIfNeeded()
        completion(controllers)
    }
    
    func changeTab(tab: Int) {
        self.selectedIndex = tab
    }
    
    func toTab(tab: Int, completion: ((Bool) -> Void)? = nil) {
        customTabBar.switchTab(from: customTabBar.activeItem, to: tab, completion: completion)
    }
    
    func openNotification(notification: UNNotificationContent) {
        guard let typeInt = Int(notification.userInfo["type"] as? String ?? ""), let type = NotificationType(rawValue: typeInt) else { return }
        switch type {
        case .threeDays:
            toTab(tab: 4, completion: { _ in
                let profileVC = (self.viewControllers?[4] as? ProfileMainViewController)
                
                guard let visualizationsIndex = profileVC?.cellTypes.firstIndex(of: .visualizations),
                      let tableView = profileVC?.profileView.tableView
                else { return }
                
                profileVC?.tableView(tableView, didSelectRowAt: .init(row: visualizationsIndex, section: 0))
            })
        case .beforeEnd:
            toTab(tab: 2, completion: { _ in
                if let vc = UIApplication.topViewController() as? DayViewController {
                    vc.openCalendar()
                }
            })
        case .end:
            toTab(tab: 1, completion: { _ in
                UIApplication.topViewController()?.present(ResultsViewController(), animated: true, completion: nil)
            })
        case .comment:
            guard let date = (notification.userInfo["date"] as? String)?.toDate(), let idStr = notification.userInfo["id"] as? String, let goalId = Int(idStr) else { return }
            if let goalDetailsController = UIApplication.topViewController() as? GoalDetailViewController {
                goalDetailsController.reload()
                return
            }
            toTab(tab: 2, completion: { _ in
                guard let vc = UIApplication.topViewController() as? DayViewController else { return }
                vc.tableVc.openGoal = goalId
                vc.chooseDate(date: date)
            })
        case .completeGoals:
            toTab(tab: 4, completion: { _ in
                guard let vc = UIApplication.topViewController() as? ProfileMainViewController else { return }
                vc.requestRate()
            })
        }
        UIApplication.setNotificationBadge(count: 0)
    }
    
    func reloadOnLanguageChange() {
        var vcs: [UIViewController] = []
        for (index, item) in tabItems.enumerated() {
            if index < tabItems.count - 1 {
                vcs.append(item.viewController)
            } else {
                if let vc = viewControllers?[index]{
                    vcs.append(vc)
                }
            }
        }
        viewControllers = vcs
    }
}

extension NavigationMenuBaseController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning()
    }
}

final class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }

        destination.alpha = 0.0
        destination.transform = .init(scaleX: 1.5, y: 1.5)
        transitionContext.containerView.addSubview(destination)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destination.alpha = 1.0
            destination.transform = .identity
        }, completion: { transitionContext.completeTransition($0) })
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }

}
