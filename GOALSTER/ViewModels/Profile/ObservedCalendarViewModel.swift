//
//  ObservedCalendarViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class ObservedCalendarViewModel {
    lazy var calendarItems = PublishSubject<[CaledarItem]>()
    
    var calendarResponse: CalendarResponse? {
        didSet {
            guard let items = calendarResponse?.items else { return }
            calendarItems.onNext(items)
        }
    }
    
    func getCelendar(observation: Int) {
        SpinnerView.showSpinnerView()
        APIManager.shared.getCalendar(observation: observation) {error, calendarRes in
            SpinnerView.completion = {
                guard let calendarRes = calendarRes else {
                    return
                }
                self.calendarResponse = calendarRes
            }
            SpinnerView.removeSpinnerView()
        }
    }
}
