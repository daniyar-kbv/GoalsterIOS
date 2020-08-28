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
    
    var response: VisualizationsResponse? {
        didSet {
            guard let spheres = response?.spheres else { return }
            self.spheres.onNext(spheres)
        }
    }
    
    func getVisualizations() {
        SpinnerView.showSpinnerView(view: view)
        APIManager.shared.getVisualizations() { error, response in
            SpinnerView.removeSpinnerView()
            guard let response = response else {
                return
            }
            self.response = response
        }
    }
}
