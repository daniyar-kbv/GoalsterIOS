//
//  AddEmotionsViewCOntroller.swift
//  GOALSTER
//
//  Created by Daniyar on 8/18/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AddEmotionsViewController: UIViewController {
    lazy var emotionsView = AddEmotionsView()
    lazy var viewModel = AddEmotionsViewModel()
    lazy var disposeBag = DisposeBag()
    var superVc: EmotionsMainViewController?
    
    override func loadView() {
        super.loadView()
        
        view = emotionsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emotionsView.addQuestions(questions: [
            ("How do I feel?".localized, "Enter here your emotion".localized),
            ("What will I can do better tomorrow".localized, "Enter here your emotion".localized),
            ("Insight".localized, "Enter here your insight".localized),
            ("Ideas (thai came during the day)".localized, "Enter here your idea".localized)
        ], onChange: onFieldsChange)
        
        emotionsView.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        emotionsView.backButton.addTarget(self, action: #selector(dismissAnimated), for: .touchUpInside)
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func bind() {
        viewModel.success.subscribe(onNext: { success in
            self.superVc?.onAppear()
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    @objc func addTapped() {
        viewModel.addEmotions(stackView: emotionsView.mainStackView)
    }
    
    func onFieldsChange() {
        var count = 0
        for view in emotionsView.mainStackView.arrangedSubviews as! [CustomFieldWithLabel]{
            if view.textView.textColor != .lightGray {
                count += 1
            }
        }
        emotionsView.addButton.isActive = count == emotionsView.mainStackView.arrangedSubviews.count
    }
}
