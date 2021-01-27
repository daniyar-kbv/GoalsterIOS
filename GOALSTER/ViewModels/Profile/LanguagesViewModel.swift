//
//  LanguagesViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class LanguagesViewModel {
    lazy var success = PublishSubject<Bool>()
    
    var view: UIView?
    
    func changeLanugage(language: Language) {
        SpinnerView.showSpinnerView()
        APIManager.shared.changeLanguage(language: language) { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    return
                }
                self.success.onNext(response)
            }
            SpinnerView.removeSpinnerView()
        }
    }
}

