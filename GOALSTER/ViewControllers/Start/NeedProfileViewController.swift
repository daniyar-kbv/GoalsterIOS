//
//  NeedProfileViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/1/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class NeedProfileViewController: UIViewController {
    lazy var mainView = NeedProfileView()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        let emailInput = (mainView.updateProfileView.arrangedSubviews as? [InputView])?.first(where: { $0.viewType == .emailUpdate })
        emailInput?.textField.isUserInteractionEnabled = false
        emailInput?.textField.text = ModuleUserDefaults.getEmail()
        emailInput?.textField.isEmpty = false
        emailInput?.textField.textColor = .gray
        
        mainView.updateProfileView.onSuccess = {
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = .fade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            let vc = ModuleUserDefaults.getIsInitial() ? AppShared.sharedInstance.tabBarController : StartViewController()
            if !(self.navigationController?.topViewController?.isKind(of: type(of: vc)) ?? false){
                self.navigationController?.pushViewController(vc, animated: false)
            }
            AppShared.sharedInstance.appLoaded = true
        }
    }
}
