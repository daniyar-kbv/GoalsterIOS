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
    lazy var sphere = PublishSubject<SphereVisualization>()
    var errorView: UIView?
    
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
            SpinnerView.completion = {
                guard let response = response else {
                    ErrorView.addToView(view: self.errorView, text: error ?? "", withName: false, disableScroll: false)
                    return
                }
                self.sphere.onNext(response)
            }
            SpinnerView.removeSpinnerView()
        }
    }
}
