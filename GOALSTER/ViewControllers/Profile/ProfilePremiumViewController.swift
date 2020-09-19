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
    lazy var premiumVc = PremiumViewController()
    
    override func loadView() {
        super.loadView()
        
        view = premiumView
        
        addChild(premiumVc)
        premiumVc.didMove(toParent: self)
        premiumView.premiumVIew.addSubview(premiumVc.view)
        premiumVc.view.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    func setOnSuccess(onSuccess: (()->())?) {
        premiumVc.premiumView.onSuccess = onSuccess
    }
    
    func showBackButton(onBack: (()->())?) {
        premiumVc.premiumView.backButton.isHidden = false
        premiumVc.premiumView.onBack = onBack
    }
}
