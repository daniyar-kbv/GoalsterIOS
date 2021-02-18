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
        
        emotionsView.addQuestions(types: [.emotion1, .emotion2, .emotion3, .emotion4], onChange: onFieldsChange)
        
        emotionsView.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func bind() {
        viewModel.emotions.subscribe(onNext: { emotions in
            self.superVc?.emotions = emotions
            self.superVc?.viewWillAppear(true)
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    @objc func addTapped() {
        viewModel.addEmotions(stackView: emotionsView.mainStackView)
    }
    
    func onFieldsChange(_ object: NSObject) {
        var count = 0
        for view in emotionsView.mainStackView.arrangedSubviews as! [InputView]{
            if !(view.textView?.isEmpty ?? true) {
                count += 1
            }
        }
        emotionsView.addButton.isActive = count == emotionsView.mainStackView.arrangedSubviews.count
    }
}
