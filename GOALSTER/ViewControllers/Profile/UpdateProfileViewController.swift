//
//  UpdateProfileViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/13/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class UpdateProfileViewController: ProfileFirstViewController {
    lazy var mainView = UpdateProfileView()
    
    override func loadView() {
        super.loadView()
        
        setView(mainView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Personal info".localized)
        
        mainView.updateView.onSuccess = {
            self.navigationController?.popViewController(animated: true)
        }
        
        hideKeyboardWhenTappedAround()
    }
}
