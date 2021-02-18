//
//  OnBoardingTextCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class OnBoardingTextCell: UICollectionViewCell {
    static let reuseIdentifier = "OnBoardingTextCell"
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = StaticSize.size(20)
        return view
    }()
    
    lazy var topText: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.textAlignment = .center
        view.font = .primary(ofSize: StaticSize.size(22), weight: .bold)
        view.textColor = .deepBlue
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
        
        backView.addSubViews([topText])
        
        topText.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
    }
}

