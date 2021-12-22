//
//  UpdateProfileView.swift
//  GOALSTER
//
//  Created by Dan on 2/13/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class UpdateProfileView: UIView {
    lazy var updateView: ProfileUpdateView = {
        let view = ProfileUpdateView(type: .update)
        view.submitButton = bottomButton
        return view
    }()
    
    lazy var bottomButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Save changes".localized, for: .normal)
        view.isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    func setUp() {
        addSubViews([updateView, bottomButton])
        
        updateView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(12))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        bottomButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
