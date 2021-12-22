//
//  ReactionViewModel.swift
//  GOALSTER
//
//  Created by Dan on 2/16/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import RxSwift

class ReactionViewModel {
    lazy var reaction = PublishSubject<Reaction>()
    
    func react(userId: Int, reactionId: Int) {
        APIManager.shared.react(userId: userId, reactionId: reactionId) { error, response in
            guard let reaction = response else { return }
            self.reaction.onNext(reaction)
        }
    }
}
