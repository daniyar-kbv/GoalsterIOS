//
//  AddEmotionsViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/18/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class AddEmotionsViewModel {
    lazy var emotions = PublishSubject<[EmotionAnswer]>()
    
    var response: EmotionsResponse? {
        didSet {
            guard let emotions = response?.emotions else { return }
            self.emotions.onNext(emotions)
        }
    }
    
    func addEmotions(stackView: UIStackView){
        var answers: [[String: Any]] = []
        for view in stackView.arrangedSubviews as! [InputView] {
            answers.append([
                "question": view.viewType.title,
                "answer": view.textView?.text ?? ""
            ])
        }
        SpinnerView.showSpinnerView()
        APIManager.shared.addEmotions(answers: answers) { error, response in
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
