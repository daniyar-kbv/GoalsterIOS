//
//  StartViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    lazy var startView = StartView()
    
    override func loadView() {
        super.loadView()
        
        view = startView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addGradientBackground()
    }
    
    func configActions() {
        startView.englishButton.addTarget(self, action: #selector(selectLanguage(_:)), for: .touchUpInside)
        startView.russianButton.addTarget(self, action: #selector(selectLanguage(_:)), for: .touchUpInside)
    }
    
    @objc func selectLanguage(_ sender: UIButton) {
        switch sender {
        case startView.russianButton:
            ModuleUserDefaults.setLanguage(.ru)
        case startView.englishButton:
            ModuleUserDefaults.setLanguage(.en)
        default:
            break
        }
        navigationController?.pushViewController(AskNotificationsViewController(), animated: true)
    }
}
