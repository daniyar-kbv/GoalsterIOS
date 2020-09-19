//
//  ResultsView.swift
//  GOALSTER
//
//  Created by Daniyar on 9/2/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ResultsView: UIView {
    lazy var topBrush: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    lazy var titleLabel: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.text = "Results title".localized
        view.font = .gotham(ofSize: StaticSize.size(32), weight: .bold)
        view.textColor = .customTextDarkPurple
        return view
    }()
    
    lazy var topText: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(14), weight: .book)
        view.textColor = .lightGray
        view.text = "Results top text".localized
        return view
    }()
    
    lazy var topText2: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(13), weight: .light)
        view.textColor = .customTextDarkPurple
        view.text = "Results top text 2".localized
        return view
    }()
    
    lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(24)
        return view
    }()
    
    lazy var bottomText: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.textColor = .customTextDarkPurple
        view.text = "Results bottom text".localized
        return view
    }()
    
    lazy var button: CustomButton = {
        let view = CustomButton()
        view.setTitle("Start new period".localized, for: .normal)
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
        addSubViews([topBrush, titleLabel, topText, topText2, stack, bottomText, button])
        
        topBrush.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(5)
            $0.width.equalTo(45)
            $0.centerX.equalToSuperview()
        })
        
        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(30))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        topText.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(-StaticSize.size(15))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        topText2.snp.makeConstraints({
            $0.top.equalTo(topText.snp.bottom).offset(-StaticSize.size(15))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        stack.snp.makeConstraints({
            $0.top.equalTo(topText2.snp.bottom).offset(-StaticSize.size(10))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        bottomText.snp.makeConstraints({
            $0.top.equalTo(stack.snp.bottom).offset(StaticSize.size(24))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        button.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.height.equalTo(StaticSize.buttonHeight)
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
    }
}
