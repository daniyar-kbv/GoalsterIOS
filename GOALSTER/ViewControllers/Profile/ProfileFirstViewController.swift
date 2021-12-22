//
//  ProfileFirstViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/13/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class ProfileFirstViewController: ProfileBaseViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppShared.sharedInstance.navigationController.delegate = self
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.delegate = self
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is NavigationMenuBaseController {
            AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = false
            AppShared.sharedInstance.navigationController.delegate = nil
        }
    }
}
