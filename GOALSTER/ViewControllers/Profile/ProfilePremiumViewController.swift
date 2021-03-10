//
//  ProfilePremiumViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ProfilePremiumViewController: ProfileFirstViewController, PremiumVC {
    lazy var premiumVc = PremiumViewController()
    var onSuccess: (()->())?
    var type: PremiumVCType = .pop
    
    override func loadView() {
        super.loadView()
        
        add(premiumVc)
        setView(premiumVc.premiumView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Premium version 2".localized)
    }
    
    func setOnSuccess(onSuccess: (()->())?) {
        self.onSuccess = onSuccess
    }
    func showBackButton(onBack: (() -> ())?) { }
}

protocol PremiumVC {
    var onSuccess: (()->())? { get set }
    var type: PremiumVCType { get set }
    
    func setOnSuccess(onSuccess: (()->())?)
    func showBackButton(onBack: (()->())?)
    func removeTop()
    func showAlertOk(title: String?, messsage: String?, okCompletion: ((UIAlertAction) -> Void)?)
}

enum PremiumVCType {
    case dismiss
    case pop
    case removeTop
}
