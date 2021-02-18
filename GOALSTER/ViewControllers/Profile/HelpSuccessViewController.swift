//
//  HelpSuccessViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/15/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class HelpSuccessViewController: ProfileFirstViewController {
    lazy var mainView = HelpSuccessView()
    
    override func loadView() {
        super.loadView()
        
        setView(mainView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.bottomButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        baseView.backButton.onBack = backTapped
        
        setTitle("Help".localized)
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: false)
        AppShared.sharedInstance.navigationController?.popViewController(animated: true)
    }
}
