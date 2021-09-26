//
//  CalendarViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    lazy var calendarViewController = CalendarBaseViewController()
    var items: [CaledarItem]? {
        didSet {
            calendarViewController.items = items
        }
    }
    var superVc: DayViewController!
    
    override func loadView() {
        super.loadView()
        
        add(calendarViewController)
        view.addSubview(calendarViewController.calendarView)
        calendarViewController.calendarView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(Global.safeAreaTop() + StaticSize.size(4))
            $0.left.right.bottom.equalToSuperview()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarViewController.onBack = back
        calendarViewController.onTap = onTap(_:)
        calendarViewController.calendarView.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addGradientBackground()
    }
    
    @objc func addTapped() {
        if !ModuleUserDefaults.getIsLoggedIn() {
            navigationController?.popViewController(animated: true)
            present(FirstAuthViewController(), animated: true, completion: nil)
        } else if !ModuleUserDefaults.getHasSpheres() {
            navigationController?.popViewController(animated: true)
            AppShared.sharedInstance.tabBarController.toTab(tab: 1)
        } else if let morning = AppShared.sharedInstance.localCalendar?.first(where: { $0.calendarItem?.date == Date().format() })?.goalsResponse?.morning?.count, let day = AppShared.sharedInstance.localCalendar?.first(where: { $0.calendarItem?.date == Date().format() })?.goalsResponse?.day?.count, let evening = AppShared.sharedInstance.localCalendar?.first(where: { $0.calendarItem?.date == Date().format() })?.goalsResponse?.evening?.count, (morning + day + evening >= 6 && !ModuleUserDefaults.getIsPremium())  {
            let premiumVC = PayBallController()
            premiumVC.onBack = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            premiumVC.onSuccess = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                self?.addTapped()
            }
            premiumVC.hideTopBrush()
            navigationController?.pushViewController(premiumVC, animated: true)
        } else {
            let vc = AddGoalViewController()
            vc.superVc = self
            vc.date = Date()
            present(vc, animated: true, completion: nil)
        }
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func onTap(_ date: Date) {
        if items?.contains(where: { $0.date == date.format() }) ?? false {
            superVc.chooseDate(date: date)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
