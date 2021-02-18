//
//  DayViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/16/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class DayViewModel {
    lazy var response = PublishSubject<GoalsResponse>()
    lazy var calendarItems = PublishSubject<[CaledarItem]>()
    var view: UIView?
    var vc: DayViewController?
    
    var calendarResponse: CalendarResponse? {
        didSet {
            guard let items = calendarResponse?.items else { return }
            calendarItems.onNext(items)
        }
    }
    
    func getGoals(date: Date, withSpinner: Bool = true) {
        if withSpinner {
            SpinnerView.showSpinnerView(view: view)
        }
        APIManager.shared.getGoals(date: date.format(), observation: nil) { error, response in
            guard let res = response else {
                SpinnerView.removeSpinnerView()
                return
            }
            APIManager.shared.getCalendar() {error, calendarRes in
                SpinnerView.completion = {
                    guard let calendarRes = calendarRes else {
                        return
                    }
                    self.calendarResponse = calendarRes
                    self.vc?.setResponse(date: date, response: res)
                }
                SpinnerView.removeSpinnerView()
            }
        }
    }
    
    func getGoalsOnly(date: Date, withSpinner: Bool = true) {
        if withSpinner {
            SpinnerView.showSpinnerView(view: view)
        }
        APIManager.shared.getGoals(date: date.format(), observation: nil) { error, response in
            SpinnerView.completion = {
                guard let res = response else {
                    SpinnerView.removeSpinnerView()
                    return
                }
                self.vc?.setResponse(date: date, response: res)
            }
            SpinnerView.removeSpinnerView()
        }
    }
}
