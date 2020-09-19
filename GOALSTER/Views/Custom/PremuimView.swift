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
    
    lazy var container: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var innerContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInsetAdjustmentBehavior = .never
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.delaysContentTouches = false
        return view
    }()
    
    lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [innerContainer])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        view.axis = .vertical
        view.alignment = .fill
        return view
    }()
    
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
    
    lazy var buttonsStack: UIStackView = {
        let view = UIStackView()
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
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.adjustsFontForContentSizeCategory = true
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
        addSubViews([container, backButton])
        
        backButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(25))
            $0.left.equalToSuperview().offset(StaticSize.size(10))
            $0.size.equalTo(StaticSize.size(30))
        })
        
        container.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview()
        })
        
        container.addSubViews([mainScrollView])
        
        mainScrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true;
        mainScrollView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true;
        mainScrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true;
        mainScrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true;

        mainScrollView.addSubview(mainStackView)

        mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true;
        mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true;
        mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true;
        mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        
        innerContainer.addSubViews([imageView, titleLabel, topText, buttonsStack, bottomFirstLabel, bottomSecondLabel])
        
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
            $0.height.equalTo(StaticSize.size(159))
        })
        
        bottomFirstLabel.snp.makeConstraints({
            $0.top.equalTo(buttonsStack.snp.bottom).offset(StaticSize.size(10))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        bottomSecondLabel.snp.makeConstraints({
            $0.top.equalTo(bottomFirstLabel.snp.bottom).offset(StaticSize.size(4))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalToSuperview()
        })
    }
    
    @objc func backTapped() {
        if let onBack = onBack {
            onBack()
        }
    }
}
