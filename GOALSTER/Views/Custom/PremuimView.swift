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
import StoreKit

class PremiumView: UIView {
    var onBack: (()->())?
    var scrolAdded = false
    
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
        view.contentInset = UIEdgeInsets(top: StaticSize.size(50), left: 0, bottom: 0, right: 0)
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
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "premium")
        view.snp.makeConstraints({
            $0.width.equalTo(StaticSize.size(180))
            $0.height.equalTo(StaticSize.size(102))
        })
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(20), weight: .semiBold)
        label.textColor = .deepBlue
        label.text = "Premium version".localized
        label.textAlignment = .center
        return label
    }()
    
    lazy var topText: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.textColor = .ultraGray
        view.text = "Premium top text".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var buttonsTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.textColor = .deepBlue
        view.text = "Premium buttons title".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        view.isHidden = true
        return view
    }()
    
    lazy var buttonsStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = StaticSize.size(10)
        return view
    }()
    
    lazy var bottomFirstLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(20), weight: .semiBold)
        label.textColor = .deepBlue
        label.text = "Premium functionality".localized
        label.textAlignment = .center
        return label
    }()
    
    lazy var bottomSecondLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.textColor = .ultraGray
        view.text = "Premium bottom text".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var topStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView, titleLabel, topText])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = StaticSize.size(15)
        return view
    }()
    
    lazy var middleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [buttonsTitleLabel, buttonsStack])
        view.distribution = .equalSpacing
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = StaticSize.size(13)
        return view
    }()
    
    lazy var bottomStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [bottomFirstLabel, bottomSecondLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(12)
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topStack, middleStack, bottomStack])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
//        view.spacing = StaticSize.size(45)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if mainStack.frame.height > StaticSize.size(60) && !scrolAdded {
            setUpWithScroll()
            scrolAdded = true
        }
    }
    
    func setUpWithScroll() {
        addSubViews([mainScrollView])

        mainScrollView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })

        mainScrollView.addSubViews([mainStackView])

        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        })

        innerContainer.addSubViews([mainStack])

        mainStack.snp.remakeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.top.bottom.equalToSuperview()
        })
        
        mainStack.spacing = StaticSize.size(45)
    }
    
    func setUp() {
        addSubViews([mainStack])
        
        mainStack.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(60))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(32))
        })
    }
    
    @objc func backTapped() {
        if let onBack = onBack {
            onBack()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PremiumButton: CustomButton {
    enum Style {
        case active
        case inactive
    }
    
    var style: Style = .active {
        didSet {
            setNeedsLayout()
        }
    }
    
    var product: SKProduct? {
        didSet {
            let titleComponents = product?.localizedTitle.localized.components(separatedBy: " ")
            numberLabel.text = titleComponents?[0]
            middleLabel.text = titleComponents?[1]
            bottomLabel.text = product?.localizedPrice
        }
    }
    
    lazy var numberLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(27), weight: .bold)
        view.textColor = .deepBlue
        return view
    }()
    
    lazy var middleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(13), weight: .regular)
        view.textColor = .deepBlue
        return view
    }()
    
    lazy var bottomLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(12), weight: .medium)
        view.textColor = .deepBlue
        return view
    }()
    
    lazy var topStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [numberLabel, middleLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = 0
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topStack, bottomLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = StaticSize.size(14)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch style {
        case .active:
            normal = toNormal
            backgroundColor = .deepBlue
            layer.borderWidth = 0
            isUserInteractionEnabled = true
            numberLabel.textColor = .arcticWhite
            middleLabel.textColor = .arcticWhite
            bottomLabel.textColor = .arcticWhite
        case .inactive:
            layer.sublayers?.first(where: { $0 is CAGradientLayer })?.removeFromSuperlayer()
            layer.borderWidth = StaticSize.size(1)
            layer.borderColor = UIColor.middlePink.cgColor
            backgroundColor = .clear
            isUserInteractionEnabled = false
            numberLabel.textColor = .deepBlue
            middleLabel.textColor = .deepBlue
            bottomLabel.textColor = .deepBlue
        }
        
        snp.remakeConstraints({
            $0.height.equalTo(frame.width)
        })
    }
    
    func setUp(){
        addSubViews([mainStack])
        
        mainStack.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(20))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(9))
            $0.left.right.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
