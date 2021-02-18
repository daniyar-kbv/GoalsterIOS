//
//  EmotionsMainViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/18/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class EmotionsMainViewModel {
    lazy var emotions = PublishSubject<[EmotionAnswer]>()
    var view: UIView?
    
    var response: EmotionsResponse? {
        didSet {
            guard let emotions = response?.emotions else { return }
            self.emotions.onNext(emotions)
        }
    }
    
    func getEmotions(withSpinner: Bool = true) {
        if withSpinner {
            SpinnerView.showSpinnerView(view: view)
        }
        APIManager.shared.getEmotions() { error, response in
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
