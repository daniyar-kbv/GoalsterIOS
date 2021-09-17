//
//  PresentablePremiumViewController.swift
//  GOALSTER
//
//  Created by Dan on 9/17/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class PresentablePremiumViewController: UIViewController, PremiumVC {
    lazy var mainView = ModalPremiumView()
    lazy var premiumVc = PremiumViewController()
    var type: PremiumVCType = .removeTop
    var onSuccess: (() -> ())?
    var onBack: (() -> ())?
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        add(premiumVc)
        mainView.contentView.addSubViews([premiumVc.premiumView])
        premiumVc.premiumView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        mainView.backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        mainView.backgroundColor = .arcticWhite
    }
    
    func setOnSuccess(onSuccess: (()->())?) {
        self.onSuccess = onSuccess
    }
    
    func showBackButton(onBack: (()->())?) {
        self.onBack = onBack
    }
    
    @objc func backTapped() {
        onBack?()
    }
}
