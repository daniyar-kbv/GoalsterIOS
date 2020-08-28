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
        viewModel.responseSubject.subscribe(onNext: { response in
            DispatchQueue.main.async {
                if let token = response.token, let spheres = response.spheres {
                    ModuleUserDefaults.setToken(token)
                    ModuleUserDefaults.setIsLoggedIn(true)
                    if spheres.count == 3 {
                        AppShared.sharedInstance.selectedSpheres = spheres
                        ModuleUserDefaults.setSpheres(value: spheres)
                        AppShared.sharedInstance.hasSpheres = true
                        ModuleUserDefaults.setHasSpheres(true)
                    }
                    self.showSuccess()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func buttonTapped(){
        viewModel.auth(email: authView.field.text ?? "")
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
