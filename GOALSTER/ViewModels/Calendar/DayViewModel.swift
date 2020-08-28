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
    
    var calendarResponse: CalendarResponse? {
        didSet {
            guard let items = calendarResponse?.items else { return }
            calendarItems.onNext(items)
        }
    }
    
    func getGoals(date: Date) {
        SpinnerView.showSpinnerView(view: view)
        APIManager.shared.getGoals(date: date.format(), observation: nil) { error, response in
            guard let res = response else {
                SpinnerView.removeSpinnerView()
                return
            }
            APIManager.shared.getCalendar() {error, calendarRes in
                SpinnerView.removeSpinnerView()
                guard let calendarRes = calendarRes else {
                    return
                }
                self.response.onNext(res)
                self.calendarResponse = calendarRes
            }
        }
    }
}
