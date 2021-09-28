//
//  OnBoardingPremiumCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class OnBoardingPremiumCell: UICollectionViewCell {
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = StaticSize.size(20)
        return view
    }()

    private lazy var mainContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var topTitle: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(20), weight: .bold)
        view.textColor = .deepBlue
        view.text = "PayBall.bottomTitle".localized
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    private lazy var topText: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(13), weight: .regular)
        view.textColor = .deepBlue
        
        let attributedText = NSMutableAttributedString(
            string: "PayBall.bottomText".localized,
            attributes: [
                NSAttributedString.Key.font: UIFont.primary(ofSize: StaticSize.size(13), weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.ultraGray
            ])
        
        (1 ..< 7).forEach {
            let substring = "PayBall.boldText.\($0)"
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
        
        view.attributedText = attributedText
        view.numberOfLines = 0
        
        view.setLineHeight(lineHeight: StaticSize.size(11))
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "onBoarding5")
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }()
    
    private lazy var buttonsTitle: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(27), weight: .regular)
        view.textColor = .deepBlue
        view.text = "On boarding bottom text 5".localized
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
    
    static let reuseIdentifier = String(describing: OnBoardingPremiumCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        contentView.addSubview(backView)
        backView.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(StaticSize.size(10))
        })
    }
    
    func setUp(plans: [(type: PlanView.PlanType, price: String)]) {
        backView.addSubview(mainContainer)
        mainContainer.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(16))
            $0.top.equalToSuperview().offset(StaticSize.size(22))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(9))
        })
        
        mainContainer.addSubViews([topTitle, topText, imageView, buttonsTitle, buttonsStack])
        
        topTitle.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
        })
        
        topText.snp.makeConstraints({
            $0.top.equalTo(topTitle.snp.bottom).offset(StaticSize.size(11))
            $0.left.right.equalToSuperview()
        })
        
        imageView.snp.makeConstraints({
            $0.top.equalTo(topText.snp.bottom).offset(StaticSize.size(25))
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualTo(StaticSize.size(189))
            $0.height.lessThanOrEqualTo(StaticSize.size(125))
        })
        
        buttonsTitle.snp.makeConstraints({
            $0.top.equalTo(imageView.snp.bottom).offset(StaticSize.size(33))
            $0.left.right.equalToSuperview()
        })
        
        buttonsStack.snp.makeConstraints({
            $0.top.equalTo(buttonsTitle.snp.bottom).offset(StaticSize.size(16))
            $0.left.right.equalToSuperview().inset(StaticSize.size(5))
            $0.bottom.equalToSuperview()
        })
        
        plans.forEach {
            let planView = PlanView(viewType: .empty, planType: $0.type, price: $0.price)
            buttonsStack.addArrangedSubview(planView)
        }
    }
}


