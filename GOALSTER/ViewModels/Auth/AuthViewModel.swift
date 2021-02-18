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
    
    var errorView: UIView?
    
    lazy var email = PublishSubject<String>()
    lazy var authResponse = PublishSubject<AuthResponse>()
    
    var response: SendCodeResponse? {
        didSet {
            guard let email = response?.email else { return }
            self.email.onNext(email)
        }
    }
    
    func sendCode(email: String) {
        SpinnerView.showSpinnerView()
        APIManager.shared.sendCode(email: email) { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    guard let error = error else {
                        let alertController = UIAlertController(title: "User with such email is not registered".localized, message: nil, preferredStyle: .alert)
                        
                        let registerAction = UIAlertAction(title: "Registration".localized, style: .default, handler: { action in
                            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                                UIApplication.topViewController()?.present(RegisterViewController(), animated: true)
                            })
                        })
                        let backAction = UIAlertAction(title: "Back".localized, style: .default, handler: nil)
                        alertController.addAction(registerAction)
                        alertController.addAction(backAction)
                        
                        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
                        return
                    }
                    ErrorView.addToView(view: self.errorView, text: error, withName: false, disableScroll: false)
                    return
                }
                self.response = response
            }
            SpinnerView.removeSpinnerView()
        }
    }
    
    func verifyOTP(email: String, code: String) {
        SpinnerView.showSpinnerView()
        APIManager.shared.verifyOTP(email: email, code: code) { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    ErrorView.addToView(view: self.errorView, text: error ?? "", withName: false, disableScroll: false)
                    return
                }
                AppShared.sharedInstance.auth(response: response)
                self.authResponse.onNext(response)
            }
            SpinnerView.removeSpinnerView()
        }
    }
}
