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
    var state: VisualizationsState?
    var showAddButton: Bool = true {
        didSet {
            if button.superview != nil && state == .added {
                button.snp.updateConstraints({
                    $0.bottom.equalToSuperview().offset(
                        showAddButton ?
                        -(StaticSize.tabBarHeight + StaticSize.size(15)) :
                        StaticSize.buttonHeight
                    )
                })
            }
        }
    }

    lazy var topText: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.textColor = .strongGray
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text = "Visualizations top text".localized
        return view
    }()
    
    lazy var animationView: AnimationView = {
        let view = AnimationView(name: "visualizations_animation")
        view.loopMode = .loop
        view.backgroundBehavior = .pauseAndRestore
        return view
    }()
    
    lazy var bottomTextView: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.textColor = .ultraGray
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text = "You have not added visalizations yet".localized
        return view
    }()
    
    lazy var button: CustomButton = {
        let view = CustomButton()
        view.setTitle("Add visualization".localized, for: .normal)
        return view
    }()
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.register(VisualizationCell.self, forCellWithReuseIdentifier: VisualizationCell.reuseIdentifier)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: StaticSize.tabBarHeight + StaticSize.buttonHeight + StaticSize.size(30), right: 0)
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
                $0.top.equalToSuperview().offset(StaticSize.size(8))
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            })
            
            animationView.snp.makeConstraints({
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(StaticSize.size(150))
                $0.width.equalTo(StaticSize.size(250))
                $0.height.equalTo(StaticSize.size(250))
            })
            
            bottomTextView.snp.makeConstraints({
                $0.top.equalTo(animationView.snp.bottom)
                $0.centerX.equalToSuperview()
            })
            
            button.snp.makeConstraints({
                $0.top.equalTo(bottomTextView.snp.bottom).offset(StaticSize.size(24))
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
                $0.height.equalTo(StaticSize.buttonHeight)
            })
            
            animationView.play()
        case .added:
            addSubViews([collection, button])
            
            collection.snp.makeConstraints({
                $0.top.equalToSuperview()
                $0.left.right.bottom.equalToSuperview()
            })
            
            button.snp.makeConstraints({
                $0.bottom.equalToSuperview().offset(
                    showAddButton ?
                    -(StaticSize.tabBarHeight + StaticSize.size(15)) :
                    StaticSize.buttonHeight
                )
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
                $0.height.equalTo(StaticSize.buttonHeight)
            })
        }
    }
}
