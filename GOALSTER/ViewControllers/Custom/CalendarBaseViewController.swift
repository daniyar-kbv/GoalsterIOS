//
//  CalendarBaseViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

class CalendarBaseViewController: UIViewController {
    lazy var calendarView = CalendarView()
    var items: [CaledarItem]? {
        didSet {
            calendarView.calendar.reloadData()
        }
    }
    var onTap: ((_ date: Date)->())?
    var onBack: (()->())?
    
    override func loadView() {
        super.loadView()
        
        view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.calendar.calendarDelegate = self
        calendarView.calendar.calendarDataSource = self
        
        calendarView.monthButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    @objc func back() {
        if let onBack = onBack {
            onBack()
        }
    }
}

extension CalendarBaseViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as! CalendarCell
        cell.number.text = date.format(format: "dd")
        if items?.contains(where: { $0.date?.toDate() == date }) ?? false{
            let item = items?.first(where: { $0.date?.toDate() == date })
            cell.isIn = true
            cell.isToday = item?.date == Date().format()
            cell.setDots(item?.goals?.first ?? false, item?.goals?.second ?? false, item?.goals?.third ?? false)
            cell.number.text = cellState.text
        }
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        return ConfigurationParameters(startDate: items?.first?.date?.toDate() ?? Date(), endDate: items?.last?.date?.toDate() ?? Date(), generateInDates: .forFirstMonthOnly, generateOutDates: .off, hasStrictBoundaries: false)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let cell = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: CalendarHeaderCell.reuseIdentifier, for: indexPath) as! CalendarHeaderCell
        cell.title.text = Month(rawValue: range.start.format(format: "MM"))?.name
        return cell
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: StaticSize.size(68))
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let onTap = onTap {
            onTap(date)
        }
    }
}

