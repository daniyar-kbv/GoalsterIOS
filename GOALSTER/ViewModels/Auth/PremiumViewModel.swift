//
//  PremiumViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 9/7/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class PremiumViewModel {
    lazy var success = PublishSubject<Bool>()
    var view: UIView?
    
    func premium(identifier: String, date: Date, productType: ProductType) {
        SpinnerView.showSpinnerView()
        APIManager.shared.premium(identifier: identifier, date: date.format(format: "dd-MM-yyyy HH:mm:ss"), productType: productType) {
            error, response in
            guard let response = response else {
                ErrorView.addToView(view: self.view, text: error ?? "", withName: false, disableScroll: false)
                return
            }
            self.success.onNext(response)
        }
    }
}
