//
//  VisulizationsMainViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/19/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class VisulizationsMainViewModel {
    var view: UIView?
    lazy var spheres = PublishSubject<[SphereVisualization]>()
    lazy var success = PublishSubject<Bool>()
    
    var response: VisualizationsResponse? {
        didSet {
            guard let spheres = response?.spheres else { return }
            self.spheres.onNext(spheres)
        }
    }
    
    func getVisualizations(withSpinner: Bool = true) {
        if withSpinner {
            SpinnerView.showSpinnerView(view: view)
        }
        APIManager.shared.getVisualizations() { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    return
                }
                self.response = response
            }
            SpinnerView.removeSpinnerView()
        }
    }
    
    func deleteVisualization(id: Int?, withSpinner: Bool = true) {
        if let id = id {
            if withSpinner {
                SpinnerView.showSpinnerView(view: view)
            }
            APIManager.shared.deleteVisualization(id: id) { error, response in
                guard response != nil else {
                    SpinnerView.removeSpinnerView()
                    return
                }
                APIManager.shared.getVisualizations() { error, response in
                    SpinnerView.completion = {
                        guard let response = response else {
                            return
                        }
                        self.response = response
                    }
                    SpinnerView.removeSpinnerView()
                }
            }
        }
    }
}
