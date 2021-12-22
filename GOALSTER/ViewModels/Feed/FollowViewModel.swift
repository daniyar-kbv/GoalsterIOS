//
//  FollowViewModel.swift
//  GOALSTER
//
//  Created by Dan on 2/17/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import RxSwift

class FollowViewModel {
    lazy var user = PublishSubject<FeedUserFull>()
    
    func follow(userId: Int) {
        APIManager.shared.follow(userId: userId) { error, response in
            guard let response = response else { return }
            self.user.onNext(response)
            AppShared.sharedInstance.followedUser = response
        }
    }
}
