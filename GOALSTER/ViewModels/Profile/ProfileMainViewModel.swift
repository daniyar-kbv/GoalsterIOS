//
//  ProfileMainViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class ProfileMainViewModel {
    var view: UIView?
    
    lazy var count = PublishSubject<Int>()
    
    var response: AuthResponse? {
        didSet {
            guard let count = response?.notConfirmedCount else { return }
            self.count.onNext(count)
        }
    }
    
    func connect() {
//        SpinnerView.showSpinnerView(view: view)
        APIManager.shared.connect(){ error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    return
                }
                AppShared.sharedInstance.auth(response: response)
                self.response = response
            }
            SpinnerView.removeSpinnerView()
        }
    }
}
