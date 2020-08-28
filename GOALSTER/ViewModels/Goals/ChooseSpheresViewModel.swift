//
//  ChooseSpheresViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/13/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class ChooseSpheresViewModel {
    let disposeBag  = DisposeBag()
    
    lazy var spheres = PublishSubject<[SelectedSphere]>()
    
    var response: ChooseSpheresResponse? {
        didSet {
            if let spheres = response?.spheres {
                DispatchQueue.global(qos: .background).async {
                    self.spheres.onNext(spheres)
                }
            }
        }
    }

    func chooseSpheres(spheres: [(key: String, value: String)]){
        var spheresParams: [[String: Any]] = []
        for sphere in spheres {
            spheresParams.append([
                "sphere": sphere.key,
                "description": sphere.value
            ])
        }
        let parameters = [
            "spheres": spheresParams
        ]
        SpinnerView.showSpinnerView()
        APIManager.shared.chooseSpheres(spheres: parameters){ error, response in
            SpinnerView.removeSpinnerView()
            guard let response = response else {
                if let error = error{
                    ErrorView.addToView(text: error)
                } else {
                    ErrorView.addToView()
                }
                return
            }
            self.response = response
        }
    }
}

