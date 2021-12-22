//
//  FirstAuthView.swift
//  GOALSTER
//
//  Created by Dan on 2/3/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class FirstAuthView: ViewWithBrush {
    lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "authBackground")
        return view
    }()
    
    lazy var logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "launchLogo")
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = StaticSize.size(10)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.snp.makeConstraints({
            $0.size.equalTo(StaticSize.size(89))
        })
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .secondary(ofSize: StaticSize.size(20), weight: .black)
        view.textColor = .deepBlue
        view.textAlignment = .center
        view.text = "24Goals"
        return view
    }()
    
    lazy var mainImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "authImage")
        view.snp.makeConstraints({
            $0.width.equalTo(StaticSize.size(265))
            $0.height.equalTo(StaticSize.size(194))
        })
        return view
    }()
    
    lazy var textLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(16), weight: .medium)
        view.textColor = .strongGray
        view.text = "Auth text".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var registerButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Sign up".localized, for: .normal)
        return view
    }()
    
    lazy var loginButton: UIButton = {
        let view = UIButton()
        let start = NSMutableAttributedString(
            string: "Already have an account?".localized,
            attributes: [
                NSAttributedString.Key.font: UIFont.primary(ofSize: StaticSize.size(16), weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ])
        let middle = NSMutableAttributedString(string: " ")
        let end = NSMutableAttributedString(
            string: "Sign in".localized,
            attributes: [
                NSAttributedString.Key.font: UIFont.primary(ofSize: StaticSize.size(16), weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.ultraPink,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.underlineColor: UIColor.ultraPink
        ])
        start.append(middle)
        start.append(end)
        view.setAttributedTitle(start, for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .arcticWhite
        
        setUp()
    }
    
    func setUp() {
        mainContainer.addSubViews([backgroundImage, logo, titleLabel, mainImage, loginButton, registerButton, textLabel])
        
        backgroundImage.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(ScreenSize.SCREEN_WIDTH * 1.212)
        })
        
        logo.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(29))
            $0.centerX.equalToSuperview()
        })
        
        titleLabel.snp.makeConstraints({
            $0.top.equalTo(logo.snp.bottom).offset(StaticSize.size(8))
            $0.centerX.equalToSuperview()
        })
        
        mainImage.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(StaticSize.size(20))
            $0.centerX.equalToSuperview()
        })
        
        loginButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        registerButton.snp.makeConstraints({
            $0.bottom.equalTo(loginButton.snp.top).offset(-StaticSize.size(20))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
        
        textLabel.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalTo(registerButton.snp.top).offset(-StaticSize.size(42))
        })
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
