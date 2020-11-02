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

class CalendarViewController: BaseViewController {
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
        setView(calendarViewController.calendarView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Calendar".localized)
        
        calendarViewController.onBack = back
        calendarViewController.onTap = onTap(_:)
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
