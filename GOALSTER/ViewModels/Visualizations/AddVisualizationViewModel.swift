//
//  AddVisualizationViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/19/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift


class AddVisualizationViewModel {
    lazy var success = PublishSubject<Bool>()
    
    func addVisualization(imageUrl: URL, sphere: Int, annotation: String?) {
        var parameters = [
            "image": imageUrl,
            "sphere": sphere
        ] as [String : Any]
        if let annotation = annotation {
            parameters["annotation"] = annotation
        }
        SpinnerView.showSpinnerView()
        APIManager.shared.addVisualization(parameters: parameters) { error, response in
            SpinnerView.removeSpinnerView()
            guard let response = response else {
                return
            }
            self.success.onNext(response)
        }
    }
}
