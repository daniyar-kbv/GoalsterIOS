//
//  SpheresSuccessViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class SpheresSuccessViewController: UIViewController {
    lazy var successView = SpheresSuccessView()
    
    override func loadView() {
        super.loadView()
        
        view = successView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        successView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        if let grandparent = parent?.parent{
            grandparent.dismiss(animated: true, completion: nil)
        } else if let parent = parent {
            parent.dismiss(animated: true, completion: nil)
        }
    }
}
