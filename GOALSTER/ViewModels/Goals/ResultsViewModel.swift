//
//  ResultsViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 9/2/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class ResultsViewModel {
    lazy var results = PublishSubject<[Result]>()
    
    var response: ResultsResponse? {
        didSet {
            guard let results = response?.results else { return }
            self.results.onNext(results)
        }
    }
    
    func getResults() {
        SpinnerView.showSpinnerView()
        APIManager.shared.results() { error, response in
            guard let response = response else {
                SpinnerView.removeSpinnerView()
                return
            }
            APIManager.shared.connect(){ error, connectResponse in
                    guard let connectResponse = connectResponse else {
                        return
                    }
                    SpinnerView.completion = {
                        AppShared.sharedInstance.auth(response: connectResponse)
                        self.response = response
                    }
                    SpinnerView.removeSpinnerView()
            }
        }
    }
}
