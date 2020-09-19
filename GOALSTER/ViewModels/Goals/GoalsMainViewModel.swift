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
    var done = PublishSubject<Bool>()
    
    var view: UIView?
    
    func todayGoals() {
        SpinnerView.showSpinnerView(view: view)
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
    
    func doneGoal(id: Int?) {
        if let id = id{
            SpinnerView.showSpinnerView(view: view)
            APIManager.shared.doneGoal(id: id) { error, response in
                SpinnerView.completion = {
                    guard let response = response else {
                        return
                    }
                    self.done.onNext(response)
                }
                SpinnerView.removeSpinnerView()
            }
        }
    }
}
