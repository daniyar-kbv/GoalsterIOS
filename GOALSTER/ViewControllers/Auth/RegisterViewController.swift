//
//  RegisterViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/4/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    lazy var mainView = RegisterView()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        mainView.updateProfileView.onSuccess = {
            guard let email = self.mainView.updateProfileView.email else { return }
            self.dismiss(animated: true, completion: {
                AppShared.sharedInstance.navigationController.present(CodeViewController(email: email), animated: true)
            })
        }
    }
}
