//
//  FeedViewModel.swift
//  GOALSTER
//
//  Created by Dan on 2/16/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import RxSwift

class FeedViewModel {
    var vc: FeedViewController
    var currentPage = 0
    var totalPages = 1
    var users: [FeedUser] = []
    
    required init(vc: FeedViewController) {
        self.vc = vc
    }
    
    var response: FeedResponse? {
        didSet {
            guard let users = response?.results, let totalPages = response?.totalPages else { return }
            self.users.append(contentsOf: users)
            vc.users = self.users
            self.totalPages = totalPages
        }
    }
    
    func feed(type: String, withSpinner: Bool = true) {
        guard currentPage < totalPages else { return }
        currentPage += 1
        if withSpinner {
            vc.mainView.showSpinnerViewBottom()
        }
        APIManager.shared.feed(type: type, page: currentPage) { error, resnpose in
            SpinnerView.removeSpinnerViewBottom()
            guard let response = resnpose else { return }
            self.response = response
        }
    }
}
