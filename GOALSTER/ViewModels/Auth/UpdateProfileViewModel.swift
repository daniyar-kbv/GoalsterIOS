//
//  UpdateProfileViewModel.swift
//  GOALSTER
//
//  Created by Dan on 2/2/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import RxSwift

class UpdateProfileViewModel {
    lazy var response = PublishSubject<UpdateProfileResponse>()
    lazy var registerResponse = PublishSubject<RegisterResponse>()
    var errorView: UIView?
    
    func updateProfile(name: String, specialization: String, email: String, instagramUsername: String, avatarUrl: URL?) {
        var parameters = [
            "name": name,
            "specialization": specialization,
            "email": email,
            "instagram_username": instagramUsername
        ] as [String : Any]
        if let url = avatarUrl {
            parameters["avatar"] = url
        }
        SpinnerView.showSpinnerView()
        APIManager.shared.updateProfile(parameters: parameters) { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    ErrorView.addToView(view: self.errorView, text: error ?? "", withName: false, disableScroll: false)
                    return
                }
                self.response.onNext(response)
            }
            SpinnerView.removeSpinnerView()
        }
    }
    
    func register(name: String, specialization: String, email: String, instagramUsername: String, avatarUrl: URL) {
        let parameters = [
            "email": email,
            "profile.name": name,
            "profile.specialization": specialization,
            "profile.instagram_username": instagramUsername,
            "profile.avatar": avatarUrl
        ] as [String : Any]
        SpinnerView.showSpinnerView()
        APIManager.shared.register(parameters: parameters) { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    ErrorView.addToView(view: self.errorView, text: error ?? "", withName: false, disableScroll: false)
                    return
                }
                self.registerResponse.onNext(response)
            }
            SpinnerView.removeSpinnerView()
        }
    }
}
