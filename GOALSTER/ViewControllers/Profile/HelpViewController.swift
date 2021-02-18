//
//  HelpViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class HelpViewController: ProfileFirstViewController {
    lazy var helpView = HelpView()
    lazy var viewModel = HelpViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var textFieldVc = TextFieldViewController(textView: helpView.fakeTextView, parentVc: self)
    
    var success: Bool? {
        didSet {
            navigationController?.pushViewController(HelpSuccessViewController(), animated: true)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        setView(helpView)
        setTitle("Help".localized)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        addChild(textFieldVc)
        textFieldVc.view.snp.makeConstraints({
            $0.size.equalTo(0)
        })
        helpView.addSubview(textFieldVc.mainView.textView)
        textFieldVc.mainView.textView.snp.makeConstraints({
            $0.top.equalTo(helpView.topTextLabel.snp.bottom).offset(StaticSize.size(12))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalToSuperview().offset(-(StaticSize.buttonHeight + StaticSize.size(30)))
        })
        
        textFieldVc.mainView.nextButton.setTitle("Send".localized, for: .normal)
        textFieldVc.mainView.nextButton.isActive = false
        textFieldVc.mainView.nextButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        textFieldVc.mainView.textView.onChange = onChange(_:)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textFieldVc.mainView.textView.becomeFirstResponder()
    }
    
    func onChange(_ textView: UITextView) {
        textFieldVc.mainView.nextButton.isActive = textFieldVc.mainView.textView.text.count != 0
    }
    
    @objc func buttonTapped() {
        viewModel.help(text: textFieldVc.mainView.textView.text)
    }
    
    func bind() {
        viewModel.success.subscribe(onNext: { success in
            DispatchQueue.main.async {
                self.success = success
            }
        }).disposed(by: disposeBag)
    }
}
