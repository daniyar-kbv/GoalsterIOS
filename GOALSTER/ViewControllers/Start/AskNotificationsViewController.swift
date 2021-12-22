//
//  AskNotificationsViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/3/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class AskNotificationsViewController: UIViewController {
    lazy var mainView = AskNotificationsView()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in (mainView.buttonStack.arrangedSubviews as? [CustomButton]) ?? [] {
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc func buttonTapped(_ button: UIButton) {
        switch button.tag {
        case 1:
            navigationController?.pushViewController(OnBoardingViewController(), animated: true)
        case 2:
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.showAlertOk(title: error.localizedDescription)
                    }
                    self.navigationController?.pushViewController(OnBoardingViewController(), animated: true)
                }
            }
        default:
            break
        }
    }
}
