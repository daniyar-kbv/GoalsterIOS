//
//  NavigationBaseController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class NavigationMenuBaseController: UITabBarController {
    
    var customTabBar: TabNavigationMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTabBar()
    }
    
    private func loadTabBar() {
        let tabItems: [TabItem] = [.goals, .emotions, .calendar, .visualizations, .profile]
        
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
    
    func toTab(tab: Int) {
        customTabBar.switchTab(from: customTabBar.activeItem, to: tab)
    }
}
