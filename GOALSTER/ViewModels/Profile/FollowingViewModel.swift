//
//  FollowersViewModel.swift
//  GOALSTER
//
//  Created by Dan on 2/17/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import RxSwift

class FollowingViewModel {
    lazy var users = PublishSubject<[FeedUserFull]>()
    
    var view: UIView?
    
    func getFollowing() {
        SpinnerView.showSpinnerView()
        APIManager.shared.following() { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    print(error)
                    return
                }
                self.users.onNext(response)
            }
            SpinnerView.removeSpinnerView()
        }
    }
}
