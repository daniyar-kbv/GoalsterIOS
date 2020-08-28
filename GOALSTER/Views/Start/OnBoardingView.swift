//
//  OnBoardingView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class OnBoardingView: UIView {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.register(OnBoardingCell.self, forCellWithReuseIdentifier: OnBoardingCell.reuseIdentifier)
        view.register(OnBoardingTextCell.self, forCellWithReuseIdentifier: OnBoardingTextCell.reuseIdentifier)
        view.register(OnBoardingPremiumCell.self, forCellWithReuseIdentifier: OnBoardingPremiumCell.reuseIdentifier)
        return view
    }()
    
    lazy var indicatorView: IndicatorView = {
        let view = IndicatorView(number: 5)
        return view
    }()
    
    lazy var nextButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Next".localized, for: .normal)
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
        addSubViews([collectionView, indicatorView, nextButton])
        
        collectionView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(Global.safeAreaTop() + StaticSize.size(15))
            $0.left.right.equalToSuperview()
            $0.height.equalTo(StaticSize.size(610))
        })
        
        indicatorView.snp.makeConstraints({
            $0.top.equalTo(collectionView.snp.bottom).offset(StaticSize.size(18))
            $0.height.equalTo(StaticSize.size(8))
            $0.width.equalTo(StaticSize.size(80))
            $0.centerX.equalToSuperview()
        })
        
        nextButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
}
