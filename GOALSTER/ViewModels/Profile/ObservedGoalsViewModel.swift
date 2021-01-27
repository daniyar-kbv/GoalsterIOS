//
//  ObservedGoalsViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class ObservedGoalsViewModel {
    lazy var response = PublishSubject<GoalsResponse>()
    lazy var calendarItems = PublishSubject<[CaledarItem]>()
    var view: UIView?
    
    var calendarResponse: CalendarResponse? {
        didSet {
            guard let items = calendarResponse?.items else { return }
            calendarItems.onNext(items)
        }
    }
    
    func getGoals(date: Date, observation: Int) {
        SpinnerView.showSpinnerView(view: view)
        APIManager.shared.getGoals(date: date.format(), observation: observation) { error, response in
            guard let res = response else {
                SpinnerView.removeSpinnerView()
                return
            }
            APIManager.shared.getCalendar(observation: observation) {error, calendarRes in
                SpinnerView.completion = {
                    guard let calendarRes = calendarRes else {
                        return
                    }
                    self.response.onNext(res)
                    self.calendarResponse = calendarRes
                }
                SpinnerView.removeSpinnerView()
            }
        }
    }
}

