//
//  SearchObserverViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class SearchObserverViewModel {
    lazy var users = PublishSubject<[User]>()
    
    var response: SearchResponse? {
        didSet {
            guard let users = response?.users else { return }
            self.users.onNext(users)
        }
    }
    
    func searchObserver(q: String) {
        APIManager.shared.searchObserver(q: q) { error, response in
            guard let response = response else { return }
            self.response = response
        }
    }
}
