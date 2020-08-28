//
//  ProfilePremiumViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ProfilePremiumViewController: UIViewController {
    lazy var premiumView = ProfilePremiumView()
    
    override func loadView() {
        super.loadView()
        
        view = premiumView
    }
    
    func setOnSuccess(onSuccess: (()->())?) {
        premiumView.premiumVIew.onSuccess = onSuccess
    }
    
    func showBackButton(onBack: (()->())?) {
        premiumView.premiumVIew.backButton.isHidden = false
        premiumView.premiumVIew.onBack = onBack
    }
}
