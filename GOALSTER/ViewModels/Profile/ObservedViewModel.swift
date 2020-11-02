//
//  ObservedViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ObservedViewModel {
    lazy var observed = PublishSubject<[Observed]>()
    
    var observedResponse: ObservedResponse? {
        didSet {
            guard let observed = observedResponse?.observed else { return }
            self.observed.onNext(observed)
        }
    }
    
    func getObserved() {
        SpinnerView.showSpinnerView()
        APIManager.shared.getObserved() { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    return
                }
                self.observedResponse = response
            }
            SpinnerView.removeSpinnerView()
        }
    }
    
    func acceptObservation(id: Int, isConfirmed: Bool) {
        SpinnerView.showSpinnerView()
        APIManager.shared.acceptObservation(id: id, isConfirmed: isConfirmed) { error, response in
            guard response != nil else {
                SpinnerView.removeSpinnerView()
                return
            }
            APIManager.shared.getObserved() { error, response in
                SpinnerView.completion = {
                    guard let response = response else {
                        return
                    }
                    self.observedResponse = response
                }
                SpinnerView.removeSpinnerView()
            }
        }
    }
}
