//
//  NoInternetViewController.swift
//  Samokat
//
//  Created by Daniyar on 7/15/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class NoInternetViewController: UIViewController {
    lazy var internetView = NoInternetView()
    var isNavigationBarHidden: Bool!
    
    override func loadView() {
        super.loadView()
        
        view = internetView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isNavigationBarHidden = AppShared.sharedInstance.navigationController.isNavigationBarHidden
        AppShared.sharedInstance.navigationController.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppShared.sharedInstance.navigationController.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppShared.sharedInstance.navigationController.isNavigationBarHidden = isNavigationBarHidden
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addGradientBackground()
    }
}
