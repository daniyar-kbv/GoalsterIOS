//
//  AuthView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class AuthView: UIView {
    lazy var image: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "envelope")
        return view
    }()
    
    lazy var text: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.textColor = .lightGray
        view.text = "Enter your email, we will send application login link on it".localized
        return view
    }()
    
    lazy var field: UITextField = {
        let view = UITextField()
        view.placeholder = "example@mail.com"
        view.font = .gotham(ofSize: StaticSize.size(32), weight: .bold)
        view.textColor = .customTextBlack
        view.keyboardType = .emailAddress
        view.textContentType = .emailAddress
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var inputButtonView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var nextButton: CustomButton = {
        let view = CustomButton()
        view.isActive = false
        view.setTitle("Sign in".localized, for: .normal)
        return view
    }()
    
    lazy var successView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var successLabel: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.textColor = .customTextDarkPurple
        view.text = "Check Your Email".localized
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([image, text, field])
        
        image.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(20))
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.size.equalTo(StaticSize.size(100))
        })
        
        text.snp.makeConstraints({
            $0.top.equalTo(image.snp.bottom).offset(StaticSize.size(37))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        field.snp.makeConstraints({
            $0.top.equalTo(text.snp.bottom).offset(StaticSize.size(25))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
    }
    
    func setUpSuccessView() {
        successView.addSubViews([image, successLabel])
        
        image.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(150))
            $0.centerX.equalToSuperview()
        })
        
        successLabel.snp.makeConstraints({
            $0.top.equalTo(image.snp.bottom).offset(StaticSize.size(37))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
    }
}
