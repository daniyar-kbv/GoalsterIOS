//
//  AddGoalViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class AddGoalViewModel {
    lazy var response = PublishSubject<Goal>()
    
    func addGoal(name: String?, time: TimeOfTheDay?, date: Date?, user: User?, isShared: Bool, sphere: SelectedSphere?, isPublic: Bool) {
        if let name = name, let sphereId = sphere?.id, let date = date, let time = time {
            let selectedUser = user?.id
            if isShared && selectedUser == nil{
                return
            }
            SpinnerView.showSpinnerView()
            APIManager.shared.addGoal(name: name, date: date.format(), time: time, isShared: isShared, observer: selectedUser, sphere: sphereId, isPublic: isPublic) { error, response in
                SpinnerView.completion = {
                    guard let response = response else {
                        if let error = error {
                            ErrorView.addToView(text: error)
                        }
                        return
                    }
                    self.response.onNext(response)
                }
                SpinnerView.removeSpinnerView()
            }
        }
    }
    
    func updateGoal(goalId: Int?, name: String?, time: TimeOfTheDay?, date: Date?, user: User?, isShared: Bool, sphere: SelectedSphere?, isPublic: Bool) {
        if let goalId = goalId, let name = name, let sphereId = sphere?.id, let date = date, let time = time {
            let selectedUser = user?.id
            if isShared && selectedUser == nil{
                return
            }
            SpinnerView.showSpinnerView()
            APIManager.shared.updateGoal(goalId: goalId, name: name, date: date.format(), time: time, isShared: isShared, observer: selectedUser, sphere: sphereId, isPublic: isPublic) { error, response in
                SpinnerView.completion = {
                    guard let response = response else {
                        if let error = error {
                            ErrorView.addToView(text: error)
                        }
                        return
                    }
                    self.response.onNext(response)
                }
                SpinnerView.removeSpinnerView()
            }
        }
    }
}
