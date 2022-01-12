//
//  FeedDetailViewModel.swift
//  GOALSTER
//
//  Created by Dan on 2/17/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import RxSwift

class FeedDetailViewModel {
    lazy var user = PublishSubject<FeedUserFull>()
    
    var view: UIView?
    
    func getUser(userId: Int, isCelebrity: Bool) {
        SpinnerView.showSpinnerView(view: view)
        APIManager.shared.feedDetail(userId: userId, isCelebrity: isCelebrity) { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    print(error)
                    return
                }
                self.user.onNext(response)
            }
            SpinnerView.removeSpinnerView()
        }
    }
}
