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
        label.font = .secondary(ofSize: StaticSize.size(34), weight: .black)
        label.textColor = .deepBlue
        label.text = "24Goals"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "startLogo")
        return view
    }()
    
    lazy var text: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.textColor = .ultraGray
        view.text = "The application will help you gain the skill of effective achievement all your bright goals, keeping your life balance and motivation"
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var chooseLanguageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .strongGray
        label.font = .primary(ofSize: StaticSize.size(14), weight: .regular)
        label.text = "Choose language"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var innerStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [logo, topTitle])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = StaticSize.size(15)
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [innerStack, text])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(24)
        return view
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
        addSubViews([mainStack, chooseLanguageLabel, englishButton, russianButton])
        
        logo.snp.makeConstraints({
            $0.size.equalTo(StaticSize.size(100))
        })
        
        mainStack.snp.makeConstraints({
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
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
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
    }
}
