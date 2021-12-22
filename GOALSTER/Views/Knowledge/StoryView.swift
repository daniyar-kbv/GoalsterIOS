//
//  StoryView.swift
//  GOALSTER
//
//  Created by Dan on 9/21/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class StoryView: UIView {
    private(set) lazy var indicatorStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = StaticSize.size(4)
        return view
    }()
    
    private(set) lazy var mainCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(StoryCell.self, forCellWithReuseIdentifier: String(describing: StoryCell.self))
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubViews([indicatorStackView, mainCollection])
        
        indicatorStackView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(17))
            $0.left.right.equalToSuperview().inset(StaticSize.size(19))
            $0.height.equalTo(StaticSize.size(4))
        })
        
        mainCollection.snp.makeConstraints({
            $0.top.equalTo(indicatorStackView.snp.bottom).offset(StaticSize.size(10))
            $0.left.right.bottom.equalToSuperview()
        })
    }
}

extension StoryView {
    func reloadIndicators(index: Int, number: Int) {
        indicatorStackView.arrangedSubviews.forEach {
            indicatorStackView.removeArrangedSubview($0)
        }
        indicatorStackView.addArrangedSubViews((0 ..< number).map {
            IndicatorView(isActive: index >= $0)
        })
    }
    
    private class IndicatorView: UIView {
        init(isActive: Bool) {
            super.init(frame: .zero)
            
            backgroundColor = isActive ? .ultraPink : .softPink
            layer.cornerRadius = StaticSize.size(1.5)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

