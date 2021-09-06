//
//  AskNotificationsViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/3/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class AskNotificationsView: UIView {
    lazy var mainImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "notification")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(20), weight: .semiBold)
        view.textColor = .deepBlue
        view.text = "Ask notification title".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var textLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.textColor = .deepBlue
        view.text = "Ask notification text".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var textStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, textLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(13)
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mainImage, textStack])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = StaticSize.size(31)
        return view
    }()
    
    lazy var noButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("No".localized, for: .normal)
        view.normal = {
            view.layer.borderWidth = StaticSize.size(1)
            view.layer.borderColor = UIColor.ultraPink.cgColor
            view.setTitleColor(.ultraPink, for: .normal)
            view.backgroundColor = .clear
        }
        view.pressed = {
            view.backgroundColor = .middleBlue
        }
        view.tag = 1
        return view
    }()
    
    lazy var yesButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Yes".localized, for: .normal)
        view.tag = 2
        return view
    }()
    
    lazy var buttonStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [noButton, yesButton])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = StaticSize.size(17)
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
        addSubViews([mainStack, buttonStack])
        
        mainImage.snp.makeConstraints({
            $0.width.equalTo(StaticSize.size(107))
            $0.height.equalTo(StaticSize.size(214))
        })
        
        mainStack.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
        })
        
        buttonStack.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
