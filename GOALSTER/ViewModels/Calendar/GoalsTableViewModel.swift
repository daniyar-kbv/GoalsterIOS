//
//  GoalsTableViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class GoalsTableViewModel {
    lazy var done = PublishSubject<Bool>()
    lazy var isMain = true
    
    var view: UIView?
    
    func doneGoal(id: Int?, withSpnner: Bool = true) {
        if let id = id{
            SpinnerView.showSpinnerView(view: view)
            APIManager.shared.doneGoal(id: id) { error, response in
                if self.isMain {
                    SpinnerView.completion = {
                        guard let response = response else {
                            return
                        }
                        self.done.onNext(response)
                    }
                    SpinnerView.removeSpinnerView()
                } else {
                    guard let response = response else {
                        SpinnerView.removeSpinnerView()
                        return
                    }
                    AppShared.sharedInstance.doneGoalResponse.onNext(response)
                }
            }
        }
    }
}
