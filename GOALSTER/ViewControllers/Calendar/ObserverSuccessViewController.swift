//
//  ObserverSuccessViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ObserverSuccessViewController: UIViewController {
    lazy var successView = ObserverSuccessView()
    var user: User?
    
    override func loadView() {
        super.loadView()
        
        view = successView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        successView.button.addTarget(self, action: #selector(backToGoal), for: .touchUpInside)
    }
    
    @objc func backToGoal() {
        if let grandparentVc = parent?.parent as? AddGoalViewController {
            grandparentVc.selectedObserver = user
            parent?.removeTop()
        }
    }
}
