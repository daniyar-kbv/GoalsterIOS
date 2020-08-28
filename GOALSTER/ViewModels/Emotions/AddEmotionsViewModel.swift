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
    lazy var success = PublishSubject<Bool>()
    
    func addEmotions(stackView: UIStackView){
        var answers: [[String: Any]] = []
        for view in stackView.arrangedSubviews as! [CustomFieldWithLabel] {
            answers.append([
                "question": view.label.text ?? "",
                "answer": view.textView.text
            ])
        }
        SpinnerView.showSpinnerView()
        APIManager.shared.addEmotions(answers: answers) { error, response in
            SpinnerView.removeSpinnerView()
            guard let response = response else {
                return
            }
            self.success.onNext(response)
        }
    }
}
