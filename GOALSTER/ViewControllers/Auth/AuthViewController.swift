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

class AuthViewController: BaseViewController {
    lazy var authView = AuthView()
    lazy var viewModel = AuthViewModel()
    lazy var disposeBag = DisposeBag()
    var button: CustomButton?
    
    override func loadView() {
        super.loadView()
        
        showGradient = false
        showBrush()
        setView(authView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Sign in".localized)
        
        button = authView.field.addButton(view: view) as? CustomButton
        button?.setTitle("Sign in".localized, for: .normal)
        button?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        authView.field.addTarget(self, action: #selector(fieldChanged(_:)), for: .editingChanged)
        view.layoutIfNeeded()
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        authView.field.becomeFirstResponder()
    }
    
    func bind() {
        viewModel.success.subscribe(onNext: { success in
            DispatchQueue.main.async {
                self.showSuccess()
            }
        }).disposed(by: disposeBag)
        viewModel.responseSubject.subscribe(onNext: { response in
            DispatchQueue.main.async {
                AppShared.sharedInstance.auth(response: response)
                self.dismiss(animated: true, completion: nil)
                if !(response.spheres?.count == 3) {
                    AppShared.sharedInstance.tabBarController.toTab(tab: 0)
                    UIApplication.topViewController()?.present(SpheresListViewController(), animated: true, completion: nil)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func buttonTapped(){
        viewModel.verify(email: authView.field.text ?? "")
//        viewModel.tempAuth(email: authView.field.text ?? "")
        authView.field.resignFirstResponder()
    }
    
    @objc func fieldChanged(_ textField: UITextField) {
        button?.isActive = textField.text?.isValidEmail() ?? false
    }
    
    func showSuccess() {
        baseView.addSubViews([authView.successView])
        
        authView.successView.snp.makeConstraints({
            $0.top.equalTo(baseView.topBrush.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        })
        
        authView.setUpSuccessView()
    }
}
