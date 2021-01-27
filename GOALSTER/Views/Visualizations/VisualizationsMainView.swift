//
//  VisualizationsMainView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/19/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class VisualizationsMainView: UIView {

    lazy var topText: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(14), weight: .book)
        view.textColor = .lightGray
        view.text = "Visualizations top text".localized
        return view
    }()
    
    lazy var animationView: AnimationView = {
        let view = AnimationView(name: "visualizations_animation")
        view.loopMode = .loop
        return view
    }()
    
    lazy var bottomTextView: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.textColor = .customLightGray
        view.textAlignment = .center
        view.text = "You have not added visalizations yet".localized
        return view
    }()
    
    lazy var button: CustomButton = {
        let view = CustomButton()
        view.setTitle("Add".localized, for: .normal)
        return view
    }()
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.register(VisualizationCell.self, forCellWithReuseIdentifier: VisualizationCell.reuseIdentifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(state: VisualizationsState) {
        for view in subviews {
            view.removeFromSuperview()
        }
        
        switch state {
        case .notAdded:
            addSubViews([topText, animationView, bottomTextView, button])
            
            topText.snp.makeConstraints({
                $0.top.equalToSuperview().offset(StaticSize.size(18))
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            })
            
            animationView.snp.makeConstraints({
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(StaticSize.size(150))
                $0.width.equalTo(StaticSize.size(250))
                $0.height.equalTo(StaticSize.size(250))
            })
            
            bottomTextView.snp.makeConstraints({
                $0.top.equalTo(animationView.snp.bottom).offset(StaticSize.size(23))
                $0.centerX.equalToSuperview()
            })
            
            button.snp.makeConstraints({
                $0.top.equalTo(bottomTextView.snp.bottom).offset(StaticSize.size(10))
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
                $0.height.equalTo(StaticSize.buttonHeight)
            })
            
            animationView.play()
        case .added:
            addSubViews([collection])
            
            collection.snp.makeConstraints({
                $0.top.equalToSuperview().offset(StaticSize.size(15))
                $0.left.right.bottom.equalToSuperview()
            })
        }
    }
}
