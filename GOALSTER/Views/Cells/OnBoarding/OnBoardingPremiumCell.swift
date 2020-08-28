//
//  OnBoardingPremiumCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class OnBoardingPremiumCell: UICollectionViewCell {
    static let reuseIdentifier = "OnBoardingPremiumCell"
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = StaticSize.size(20)
        return view
    }()
    
    lazy var premiumView: PremiumView = {
        let view = PremiumView()
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
        
        backView.addSubViews([premiumView])
        
        premiumView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}


