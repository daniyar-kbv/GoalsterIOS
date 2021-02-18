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
        ModuleUserDefaults.setIsPurchaseProcessed(false)
        ModuleUserDefaults.setLastPurchase(object: PremiumPurchase(productType: productType, identifier: identifier, date: date))
        APIManager.shared.premium(identifier: identifier, date: date.format(format: "dd-MM-yyyy HH:mm:ss"), productType: productType) {
            error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    self.premium(identifier: identifier, date: date, productType: productType)
                    return
                }
                ModuleUserDefaults.setIsPurchaseProcessed(true)
                self.success.onNext(response)
            }
            SpinnerView.removeSpinnerView()
        }
    }
}
