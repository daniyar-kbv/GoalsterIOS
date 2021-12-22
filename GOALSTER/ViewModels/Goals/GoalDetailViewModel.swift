//
//  GoalDetailViewModel.swift
//  GOALSTER
//
//  Created by Dan on 2/11/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import RxSwift

class GoalDetailViewModel {
    lazy var commentId = PublishSubject<Int>()
    lazy var comments = PublishSubject<[Comment]>()
    
    var view: UIView?
    
    func getComments(goalId: Int, withSpinner: Bool = true) {
        if withSpinner {
            SpinnerView.showSpinnerView(view: view)
        }
        APIManager.shared.comments(goalId: goalId) { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    return
                }
                self.comments.onNext(response)
            }
            SpinnerView.removeSpinnerView()
        }
    }
    
    func leaveComment(goalId: Int, text: String) {
        APIManager.shared.leaveComment(goalId: goalId, text: text) { error, response in
            guard let response = response?.id else {
                return
            }
            self.commentId.onNext(response)
        }
    }
}
