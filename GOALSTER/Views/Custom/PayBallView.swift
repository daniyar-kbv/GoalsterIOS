//
//  PayballController.swift
//  GOALSTER
//
//  Created by Dan on 9/21/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class PayBallView: UIView {
    private(set) lazy var topBrush: UIView = {
        let view = UIView()
        view.backgroundColor = .middlePink
        view.layer.cornerRadius = StaticSize.size(1.75)
        return view
    }()
    
    private(set) lazy var backButton: BackButton = {
        let view = BackButton()
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentInset = .init(top: StaticSize.size(14.5), left: 0, bottom: Global.safeAreaBottom(), right: 0)
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "about")
        view.layer.cornerRadius = StaticSize.size(57.5)
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var topTitle: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.textColor = .lightBlue
        view.text = "PayBall.title".localized
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    private lazy var topSubtitle: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .bold)
        view.textColor = .deepBlue
        view.text = "PayBall.subtitle".localized
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    private lazy var topText: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(11), weight: .medium)
        view.textColor = .ultraGray
        view.text = "PayBall.topText".localized
        view.numberOfLines = 0
        view.setLineHeight(lineHeight: StaticSize.size(10))
        return view
    }()
    
    private lazy var buttonsTitle: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(27), weight: .black)
        view.textColor = .deepBlue
        view.text = "Premium version".localized
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = StaticSize.size(35)
        return view
    }()
    
    private lazy var bottomTitle: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(20), weight: .semiBold)
        view.textColor = .deepBlue
        view.text = "PayBall.bottomTitle".localized
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    private lazy var bottomText: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(11), weight: .medium)
        view.textColor = .deepBlue
        
        let attributedText = NSMutableAttributedString(
            string: "PayBall.bottomText".localized,
            attributes: [
                NSAttributedString.Key.font: UIFont.primary(ofSize: StaticSize.size(13), weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.ultraGray
            ])
        
        (1 ..< 7).forEach {
            let substring = "PayBall.boldText.\($0)".localized
            guard let range = attributedText.string.range(of: substring) else { return }
            let nsRange = NSRange(range, in: attributedText.string)
            attributedText.replaceCharacters(
                in: nsRange,
                with: .init(
                    string: substring,
                    attributes: [
                        NSAttributedString.Key.font: UIFont.primary(ofSize: StaticSize.size(13), weight: .bold),
                        NSAttributedString.Key.foregroundColor: UIColor.ultraGray
                    ]
                )
            )
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 11
        attributedText.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attributedText.string.count))
        
        view.attributedText = attributedText
        view.numberOfLines = 0
        
        return view
    }()
    
    var buttonTapped: ((PlanView.PlanType) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .arcticWhite
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubViews([topBrush, backButton, scrollView])
        
        topBrush.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(6))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(StaticSize.size(36))
            $0.height.equalTo(StaticSize.size(3.5))
        })
        
        backButton.snp.makeConstraints({
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(StaticSize.size(30))
            $0.left.equalToSuperview().offset(StaticSize.size(7))
            $0.size.equalTo(StaticSize.size(30))
        })
    }
    
    func setUp(plans: [(type: PlanView.PlanType, price: String)]) {
        scrollView.snp.makeConstraints({
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(StaticSize.size(10))
            $0.left.right.equalToSuperview().inset(37)
            $0.bottom.equalToSuperview()
        })
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints({
            $0.edges.width.equalToSuperview()
        })
        
        contentView.addSubViews([imageView, topTitle, topSubtitle, topText, buttonsTitle, buttonsStack, bottomTitle, bottomText])
        
        imageView.snp.makeConstraints({
            $0.top.left.equalToSuperview()
            $0.size.equalTo(StaticSize.size(115))
        })
        
        topTitle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(22))
            $0.left.equalTo(imageView.snp.right).offset(StaticSize.size(16))
            $0.right.equalToSuperview()
        })
        
        topSubtitle.snp.makeConstraints({
            $0.top.equalTo(topTitle.snp.bottom).offset(StaticSize.size(4))
            $0.left.right.equalTo(topTitle)
        })
        
        topText.snp.makeConstraints({
            $0.top.equalTo(imageView.snp.bottom).offset(StaticSize.size(10))
            $0.left.right.equalToSuperview()
        })
        
        buttonsTitle.snp.makeConstraints({
            $0.top.equalTo(topText.snp.bottom).offset(StaticSize.size(32))
            $0.left.right.equalToSuperview()
        })
        
        buttonsStack.snp.makeConstraints({
            $0.top.equalTo(buttonsTitle.snp.bottom).offset(StaticSize.size(16))
            $0.left.right.equalToSuperview()
        })
        
        plans.forEach {
            let planView = PlanView(viewType: .filled, planType: $0.type, price: $0.price)
            planView.buttonTapped = buttonTapped
            buttonsStack.addArrangedSubview(planView)
        }
        
        bottomTitle.snp.makeConstraints({
            $0.top.equalTo(buttonsStack.snp.bottom).offset(StaticSize.size(35))
            $0.left.right.equalToSuperview()
        })
        
        bottomText.snp.makeConstraints({
            $0.top.equalTo(bottomTitle.snp.bottom).offset(StaticSize.size(10))
            $0.left.right.bottom.equalToSuperview()
        })
    }
}
