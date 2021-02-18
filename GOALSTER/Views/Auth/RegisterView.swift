//
//  RegisterView.swift
//  GOALSTER
//
//  Created by Dan on 2/4/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class RegisterView: View {
    lazy var updateProfileView: ProfileUpdateView = {
        let view = ProfileUpdateView(type: .registration)
        view.submitButton = bottomButton
        return view
    }()
    
    lazy var bottomButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Send code".localized, for: .normal)
        view.isActive = false
        return view
    }()
    
    lazy var policyLabel = PolicyLabel(type: .privacy)
    
    required init() {
        super.init()
        
        title = "Registration".localized
        subtitle = "Sign up subtitle".localized
        
        setUp()
    }
    
    func setUp() {
        contentView.addSubViews([updateProfileView, bottomButton, policyLabel])
        
        updateProfileView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(12))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        bottomButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
        
        policyLabel.snp.makeConstraints({
            $0.bottom.equalTo(bottomButton.snp.top).offset(-StaticSize.size(25))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(withBackButton: Bool = false, iconImage: UIImage? = nil) {
        fatalError("init(withBackButton:iconImage:) has not been implemented")
    }
}
