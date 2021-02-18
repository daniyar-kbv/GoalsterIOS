//
//  EmotionsMainView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/18/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class EmotionsMainView: UIView {

    lazy var topText: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.textColor = .strongGray
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text = "Emotions of the day".localized
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        label.textColor = .deepBlue
        label.textAlignment = .center
        label.text = ("Today".localized + " " + "\(Date().format(format: "d MMMM"))")
        return label
    }()
    
    lazy var animationView: AnimationView = {
        let view = AnimationView(name: "emotions_animation")
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
        view.text = "You have not added emotions today".localized
        return view
    }()
    
    lazy var progress: CollectionIndicatorView = {
        let view = CollectionIndicatorView(number: 4)
        return view
    }()
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.register(EmotionCell.self, forCellWithReuseIdentifier: EmotionCell.reuseIdentifier)
        view.isPagingEnabled = true
        return view
    }()
    
    lazy var button: CustomButton = {
        let view = CustomButton()
        view.setTitle("Add emotions".localized, for: .normal)
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
        addSubViews([topText, dateLabel])
        
        topText.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(8))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        dateLabel.snp.makeConstraints({
            $0.top.equalTo(topText.snp.bottom).offset(StaticSize.size(10))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
    }
    
    func finishSetUp(state: EmotionsState) {
        for view in subviews {
            if ![topText, dateLabel].contains(view) {
                view.removeFromSuperview()
            }
        }
        
        topText.textAlignment = state == .added ? .left : .center
        dateLabel.textAlignment = state == .added ? .left : .center
        
        switch state {
        case .notAdded:
            topText.text = "Emotions long text".localized
            
            addSubViews([animationView, bottomTextView, button])
            
            animationView.snp.makeConstraints({
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(StaticSize.size(150))
                $0.width.equalTo(StaticSize.size(350))
                $0.height.equalTo(StaticSize.size(350))
            })
            
            bottomTextView.snp.makeConstraints({
                $0.top.equalTo(animationView.snp.bottom).offset(-StaticSize.size(77))
                $0.centerX.equalToSuperview()
            })
            
            button.snp.makeConstraints({
                $0.top.equalTo(bottomTextView.snp.bottom).offset(StaticSize.size(24))
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
                $0.height.equalTo(StaticSize.buttonHeight)
            })
            
            animationView.play()
        case .added:
            topText.text = "Emotions top text".localized
            
            addSubViews([progress, collection])
            
            progress.snp.makeConstraints({
                $0.top.equalTo(dateLabel.snp.bottom).offset(StaticSize.size(16))
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
                $0.height.equalTo(StaticSize.size(4))
            })
            
            collection.snp.makeConstraints({
                $0.top.equalTo(progress.snp.bottom).offset(StaticSize.size(16))
                $0.left.right.bottom.equalToSuperview()
            })
        }
    }
}
