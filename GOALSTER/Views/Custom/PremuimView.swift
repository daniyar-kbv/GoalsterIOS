//
//  PremuimView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PremiumView: UIView {
    var onSuccess: (()->())?
    var onBack: (()->())?
    
    lazy var backButton: BackButton = {
        let view = BackButton()
        view.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "premium")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(32), weight: .bold)
        label.textColor = .customTextDarkPurple
        label.text = "Premium version".localized
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var topText: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.textColor = .customTextBlack
        view.text = "Premium top text".localized
        view.textAlignment = .center
        return view
    }()
    
    lazy var firstButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("1 month".localized, for: .normal)
        view.titleLabel?.font = .gotham(ofSize: StaticSize.size(18), weight: .medium)
        return view
    }()
    
    lazy var secondButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("3 month".localized, for: .normal)
        view.titleLabel?.font = .gotham(ofSize: StaticSize.size(18), weight: .medium)
        return view
    }()
    
    lazy var thirdButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("1 year".localized, for: .normal)
        view.titleLabel?.font = .gotham(ofSize: StaticSize.size(18), weight: .medium)
        return view
    }()
    
    lazy var buttonsStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [firstButton, secondButton, thirdButton])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(12)
        return view
    }()
    
    lazy var bottomFirstLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(16), weight: .medium)
        label.textColor = .customTextDarkPurple
        label.text = "Premium functionality".localized
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var bottomSecondLabel: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(12), weight: .book)
        view.textColor = .customTextBlack
        view.text = "Premium bottom text".localized
        view.textAlignment = .center
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
        addSubViews([backButton, imageView, titleLabel, topText, buttonsStack, bottomFirstLabel, bottomSecondLabel])
        
        backButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(25))
            $0.left.equalToSuperview().offset(StaticSize.size(10))
            $0.size.equalTo(StaticSize.size(30))
        })
        
        imageView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(34))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(StaticSize.size(100))
            $0.height.equalTo(StaticSize.size(150))
        })
        
        titleLabel.snp.makeConstraints({
            $0.top.equalTo(imageView.snp.bottom).offset(StaticSize.size(8))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        topText.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(StaticSize.size(4))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        buttonsStack.snp.makeConstraints({
            $0.top.equalTo(topText.snp.bottom).offset(StaticSize.size(15))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        firstButton.snp.makeConstraints({
            $0.height.equalTo(StaticSize.buttonHeight)
        })
        
        secondButton.snp.makeConstraints({
            $0.height.equalTo(StaticSize.buttonHeight)
        })
        
        thirdButton.snp.makeConstraints({
            $0.height.equalTo(StaticSize.buttonHeight)
        })
        
        bottomFirstLabel.snp.makeConstraints({
            $0.top.equalTo(buttonsStack.snp.bottom).offset(StaticSize.size(25))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        bottomSecondLabel.snp.makeConstraints({
            $0.top.equalTo(bottomFirstLabel.snp.bottom).offset(StaticSize.size(4))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        for button in buttonsStack.arrangedSubviews as! [CustomButton] {
            button.addTarget(self, action: #selector(testPremium), for: .touchUpInside)
        }
    }
    
    @objc func testPremium() {
        SpinnerView.showSpinnerView()
        APIManager.shared.testPremium(completion: { error, response in
            SpinnerView.removeSpinnerView()
            guard let response = response else { return }
            ModuleUserDefaults.setIsPremium(true)
            if let onSuccess = self.onSuccess {
                onSuccess()
            }
        })
    }
    
    @objc func backTapped() {
        if let onBack = onBack {
            onBack()
        }
    }
}
