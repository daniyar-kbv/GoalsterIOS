//
//  ModalPremiumViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/15/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ModalPremiumViewController: ChildViewController, PremiumVC {
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

class ModalPremiumView: View {
    required init(withBackButton: Bool = false, iconImage: UIImage? = nil) {
        super.init(withBackButton: true, iconImage: nil)
        
        title = "Purchase the premium version".localized
        titleLabel.font = .primary(ofSize: StaticSize.size(22), weight: .semiBold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
