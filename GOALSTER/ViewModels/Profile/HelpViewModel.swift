//
//  HelpViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class HelpViewModel {
    lazy var success = PublishSubject<Bool>()
    
    func help(text: String) {
        SpinnerView.showSpinnerView()
        APIManager.shared.help(text: text) { error, response in
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
