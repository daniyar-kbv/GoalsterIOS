//
//  NeedProfileView.swift
//  GOALSTER
//
//  Created by Dan on 2/1/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class NeedProfileView: UIView {
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "You must fill in the data".localized
        view.font = .primary(ofSize: StaticSize.size(17), weight: .medium)
        view.textColor = .ultraGray
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var updateProfileView: ProfileUpdateView = {
        let view = ProfileUpdateView(type: .initial)
        view.submitButton = bottomButton
        return view
    }()
    
    lazy var bottomButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Save".localized, for: .normal)
        view.isActive = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addGradientBackground()
    }
    
    func setUp() {
        addSubViews([titleLabel, updateProfileView, bottomButton])
        
        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(Global.safeAreaTop() + StaticSize.size(13))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        updateProfileView.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(StaticSize.size(26))
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
