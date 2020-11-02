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
    
    lazy var success = PublishSubject<Bool>()

    func verify(email: String){
        SpinnerView.showSpinnerView()
//        APIManager.shared.verify(email: email) { error, response in
        APIManager.shared.verify(email: email) { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    if let error = error{
                        ErrorView.addToView(text: error)
                    } else {
                        ErrorView.addToView()
                    }
                    return
                }
                if response.emailed == true {
                    self.success.onNext(true)
                } else {
                    self.response = response
                }
            }
            SpinnerView.removeSpinnerView()
        }
    }
    
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
    
    func tempAuth(email: String) {
        SpinnerView.showSpinnerView()
        APIManager.shared.tempAuth(email: email){ error, response in
            SpinnerView.completion = {
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
            SpinnerView.removeSpinnerView()
        }
    }
}
