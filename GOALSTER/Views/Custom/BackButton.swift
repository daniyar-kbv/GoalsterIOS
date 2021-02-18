//
//  BackButton.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class BackButton: UIButton {
    var onBack: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackgroundImage(UIImage(named: "backButton"), for: .normal)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapped() {
        if let onBack = onBack {
            onBack()
        } else if let vc = viewContainingController() as? ChildViewController {
            vc.removeTop()
        } else if viewContainingController()?.parent is UINavigationController {
            viewContainingController()?.navigationController?.popViewController(animated: true)
        } else {
            viewContainingController()?.dismiss(animated: true)
        }
    }
}
