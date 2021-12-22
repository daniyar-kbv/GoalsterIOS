//
//  FirstAuthViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/3/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class FirstAuthViewController: UIViewController {
    lazy var mainView = FirstAuthView()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        mainView.registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }
    
    @objc func registerTapped() {
        dismiss(animated: true, completion: {
            AppShared.sharedInstance.navigationController?.present(RegisterViewController(), animated: true)
        })
    }
    
    @objc func loginTapped() {
        dismiss(animated: true, completion: {
            AppShared.sharedInstance.navigationController?.present(AuthViewController(), animated: true)
        })
    }
}
