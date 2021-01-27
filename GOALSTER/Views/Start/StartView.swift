//
//  StartView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class StartView: UIView {
    lazy var topTitle: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(44), weight: .medium)
        label.textColor = .customTextDarkPurple
        label.text = "24Goals"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "startLogo")
        return view
    }()
    
    lazy var text: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(16), weight: .medium)
        view.textColor = .customTextBlack
        view.text = "Some text on start page".localized
        return view
    }()
    
    lazy var chooseLanguageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customLightGray
        label.font = .gotham(ofSize: StaticSize.size(14), weight: .book)
        label.text = "Choose language".localized
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var englishButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("English", for: .normal)
        return view
    }()
    
    lazy var russianButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Русский язык", for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([topTitle, logo, text, chooseLanguageLabel, englishButton, russianButton])
        
        topTitle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(125))
            $0.left.equalToSuperview().offset(StaticSize.size(15))
        })
        
        logo.snp.makeConstraints({
            $0.top.equalTo(topTitle.snp.bottom).offset(StaticSize.size(15))
            $0.centerX.equalToSuperview()
            $0.size.equalTo(StaticSize.size(300))
        })
        
        text.snp.makeConstraints({
            $0.top.equalTo(logo.snp.bottom).offset(StaticSize.size(38))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        russianButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
        
        englishButton.snp.makeConstraints({
            $0.bottom.equalTo(russianButton.snp.top).offset(-StaticSize.size(12))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
        
        chooseLanguageLabel.snp.makeConstraints({
            $0.bottom.equalTo(englishButton.snp.top).offset(-StaticSize.size(12))
            $0.left.equalToSuperview().offset(StaticSize.size(15))
        })
    }
}
