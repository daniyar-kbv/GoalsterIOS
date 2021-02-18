//
//  AuthViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AuthViewController: UIViewController {
    lazy var mainView = AuthView()
    lazy var viewModel = AuthViewModel()
    lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.nextButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        mainView.field.addTarget(self, action: #selector(fieldChanged(_:)), for: .editingChanged)
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.field.becomeFirstResponder()
    }
    
    func bind() {
        viewModel.email.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {
                    let vc = CodeViewController(email: object)
                    AppShared.sharedInstance.navigationController.present(vc, animated: true)
                })
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func buttonTapped(){
        guard let email = mainView.field.text else { return }
        viewModel.sendCode(email: email)
        mainView.field.resignFirstResponder()
    }
    
    @objc func fieldChanged(_ textField: UITextField) {
        mainView.nextButton.isActive = textField.text?.isValidEmail() ?? false
    }
}
