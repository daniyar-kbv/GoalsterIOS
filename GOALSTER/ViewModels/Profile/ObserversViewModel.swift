//
//  ObserversViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ObserversViewModel {
    lazy var observers = PublishSubject<[Observer]>()
    
    var observersResponse: ObserversResponse? {
        didSet {
            guard let observers = observersResponse?.observers else { return }
            self.observers.onNext(observers)
        }
    }
    
    func getObservers() {
        SpinnerView.showSpinnerView()
        APIManager.shared.getObservers() { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    return
                }
                self.observersResponse = response
            }
            SpinnerView.removeSpinnerView()
        }
    }
    
    func deleteObservation(id: Int) {
        SpinnerView.showSpinnerView()
        APIManager.shared.deleteObservation(id: id) { error, response in
            guard let response = response else {
                SpinnerView.removeSpinnerView()
                return
            }
            APIManager.shared.getObservers() { error, response in
                SpinnerView.completion = {
                    guard let response = response else {
                        return
                    }
                    self.observersResponse = response
                }
                SpinnerView.removeSpinnerView()
            }
        }
    }
}

