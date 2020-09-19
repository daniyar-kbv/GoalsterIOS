//
//  ObserverSuccessView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ObserverSuccessView: UIView {
    lazy var topBrush: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    lazy var titleLabel: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.text = "Observer addition".localized
        view.font = .gotham(ofSize: StaticSize.size(21), weight: .medium)
        view.textColor = .customTextDarkPurple
        return view
    }()
    
    lazy var image: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "envelope")
        return view
    }()
    
    lazy var text: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(15), weight: .book)
        view.textColor = .customTextDarkPurple
        view.text = "You have made right descision".localized
        view.textAlignment = .center
        return view
    }()
    
    lazy var button: CustomButton = {
        let view = CustomButton()
        view.setTitle("Back to goal".localized, for: .normal)
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
        addSubViews([topBrush, titleLabel, image, text, button])
        
        topBrush.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(5)
            $0.width.equalTo(45)
            $0.centerX.equalToSuperview()
        })
        
        titleLabel.snp.makeConstraints({
            $0.left.top.equalToSuperview().offset(StaticSize.size(15))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
        })
        
        image.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(StaticSize.size(110))
            $0.centerX.equalToSuperview()
            $0.size.equalTo(StaticSize.size(100))
        })
        
        text.snp.makeConstraints({
            $0.top.equalTo(image.snp.bottom).offset(StaticSize.size(37))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        button.snp.makeConstraints({
            $0.top.equalTo(text.snp.bottom).offset(StaticSize.size(18))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
}
