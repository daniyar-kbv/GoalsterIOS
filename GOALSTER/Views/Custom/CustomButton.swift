//
//  CustomButton.swift
//  Samokat
//
//  Created by Daniyar on 7/7/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import StoreKit

class CustomButton: UIButton {
    enum State {
        case normal
        case presses
        case disabled
    }
    
    var phase: State? = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    var isActive: Bool = true {
        didSet {
            phase = isActive ? .normal : .disabled
        }
    }
    
    lazy var normal = toNormal
    lazy var disabled = toDisabled
    lazy var pressed = toPressed
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = StaticSize.size(10)
        titleLabel?.font = .primary(ofSize: StaticSize.size(20), weight: .regular)
        setTitleColor(.arcticWhite, for: .normal)
        backgroundColor = .deepBlue
        
        addTarget(self, action: #selector(holdDown), for: .touchDown)
        addTarget(self, action: #selector(holdRelease), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch phase{
        case .none, .normal:
            normal()
        case .disabled:
            disabled()
        case .presses:
            pressed()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func holdDown() {
        phase = .presses
    }
    
    @objc private func holdRelease() {
        phase = .normal
    }
    
    func toNormal() {
        isUserInteractionEnabled = true
        addGradientBackground(colors: UIColor.buttonGradient, direction: .topToBottom)
    }
    
    func toDisabled() {
        isUserInteractionEnabled = false
        addGradientBackground(colors: UIColor.turnedOffGradient, direction: .topToBottom)
    }
    
    func toPressed() {
        layer.sublayers?.first(where: { $0 is CAGradientLayer })?.removeFromSuperlayer()
    }
}

class CustomButtonTwoText: CustomButton {
    lazy var leftTitle: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: StaticSize.size(16), weight: .bold)
        view.textColor = .white
        return view
    }()
    
    lazy var rightTitle: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: StaticSize.size(16), weight: .bold)
        view.textColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(){
        addSubViews([leftTitle, rightTitle])
        
        leftTitle.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(20))
            $0.centerY.equalToSuperview()
        })
        
        rightTitle.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(20))
            $0.centerY.equalToSuperview()
        })
    }
    
    func setLeftTitle(text: String) {
        leftTitle.text = text
    }
    
    func setRightTitle(text: String) {
        rightTitle.text = text
    }
}

class TappableButton: UIButton {
    var initialColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(holdDown), for: .touchUpInside)
        addTarget(self, action: #selector(holdRelease), for: .touchDown)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func holdDown() {
        backgroundColor = initialColor
    }

    @objc private func holdRelease() {
        initialColor = backgroundColor
        backgroundColor = initialColor?.withAlphaComponent(0.5)
    }
}
