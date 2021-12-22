//
//  ChildViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/10/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class ChildViewController: UIViewController {
    var parentVc: UIViewController
    
    required init(parentVc: UIViewController) {
        self.parentVc = parentVc
        
        super.init(nibName: .none, bundle: .none)
    }
    
    func backToParent() {
        removeTop()
//        dismiss(animated: true, completion: {
//            UIApplication.topViewController()?.present(self.parentVc, animated: true)
//        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
