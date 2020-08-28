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

class HelpViewController: UIViewController {
    lazy var helpView = HelpView()
    lazy var viewModel = HelpViewModel()
    lazy var disposeBag = DisposeBag()
    
    var success: Bool? {
        didSet {
            let vc = SpheresSuccessViewController()
            vc.successView.text.text = "Sent successfully!".localized
            openTop(vc: vc)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = helpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        helpView.onFieldChange = onChange
        
        helpView.addButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        hideKeyboardWhenTappedAround(textView: helpView.textView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disableKeyboardDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardDisplay()
    }
    
    func onChange() {
        helpView.addButton.isActive = helpView.textView.textColor != .lightGray
    }
    
    @objc func buttonTapped() {
        viewModel.help(text: helpView.textView.text)
    }
    
    func bind() {
        viewModel.success.subscribe(onNext: { success in
            DispatchQueue.main.async {
                self.success = success
            }
        }).disposed(by: disposeBag)
    }
}

extension HelpViewController {
    @objc override func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            AppShared.sharedInstance.openedKeyboardSize = keyboardSize
        }
        
    }
    
    @objc override func keyboardWillHide(notification: NSNotification){
    }
}
