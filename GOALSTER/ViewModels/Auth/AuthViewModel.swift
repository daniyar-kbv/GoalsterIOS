//
//  AuthViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class AuthViewModel {
    let disposeBag  = DisposeBag()
    
    lazy var responseSubject = PublishSubject<AuthResponse>()
    
    var response: AuthResponse? {
        didSet {
            if let response = response {
                DispatchQueue.global(qos: .background).async {
                    self.responseSubject.onNext(response)
                }
            }
        }
    }

    func auth(email: String){
        SpinnerView.showSpinnerView()
        APIManager.shared.auth(email: email){ error, response in
            SpinnerView.removeSpinnerView()
            guard let response = response else {
                if let error = error{
                    ErrorView.addToView(text: error)
                } else {
                    ErrorView.addToView()
                }
                return
            }
            self.response = response
        }
    }
}
