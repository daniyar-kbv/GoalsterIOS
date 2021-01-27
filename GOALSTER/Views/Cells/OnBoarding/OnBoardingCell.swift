//
//  OnBoardingCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class OnBoardingCell: UICollectionViewCell {
    static let reuseIdentifier = "OnBoardingCell"
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = StaticSize.size(20)
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var topText: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.textAlignment = .center
        view.font = .gotham(ofSize: StaticSize.size(22), weight: .bold)
        view.textColor = .customTextDarkPurple
        return view
    }()
    
    lazy var bottomText: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.textAlignment = .center
        view.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.textColor = .customTextBlack
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
        addSubViews([backView])
        
        backView.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(StaticSize.size(10))
        })
        
        backView.addSubViews([imageView, topText, bottomText])
        
        imageView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(145))
            $0.centerX.equalToSuperview()
            $0.size.equalTo(StaticSize.size(150))
        })
        
        topText.snp.makeConstraints({
            $0.top.equalTo(imageView.snp.bottom).offset(StaticSize.size(20))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        bottomText.snp.makeConstraints({
            $0.top.equalTo(topText.snp.bottom).offset(StaticSize.size(48))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
    }
}
