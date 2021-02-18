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
    
    var view: UIView?
    
    func doneGoal(id: Int?) {
        guard let id = id else { return }
        APIManager.shared.doneGoal(id: id) { error, response in
            guard let response = response else {
                return
            }
            self.done.onNext(response)
        }
    }
}
