//
//  GoalsMainViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class GoalsMainViewModel {
    lazy var response = PublishSubject<TodayGoalsResponse>()
    
    var view: UIView?
    
    func todayGoals(withSpinner: Bool = true) {
        if withSpinner {
            SpinnerView.showSpinnerView(view: view)
        }
        APIManager.shared.todayGoals() { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    return
                }
                self.response.onNext(response)
            }
            SpinnerView.removeSpinnerView()
        }
    }
}
