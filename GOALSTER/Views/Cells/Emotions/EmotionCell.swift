//
//  EmotionCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/18/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class EmotionCell: UICollectionViewCell {
    static let reuseIdentifier = "EmotionCell"
    
    lazy var mainScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInsetAdjustmentBehavior = .never
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        return view
    }()

    lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: StaticSize.size(100), trailing: 0)
        view.axis = .vertical
        view.alignment = .fill
        return view
    }()
    
    lazy var outerContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var question: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        label.textColor = .deepBlue
        label.text = "Ideas".localized
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = StaticSize.size(0.5)
        view.layer.cornerRadius = StaticSize.size(5)
        return view
    }()
    
    lazy var text: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.textColor = .ultraGray
        view.numberOfLines = 0
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
        addSubViews([mainScrollView])
        
        mainScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true;
        mainScrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true;
        mainScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true;
        mainScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true;

        mainScrollView.addSubview(mainStackView)

        mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true;
        mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true;
        mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true;
        mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        
        mainStackView.addArrangedSubViews([outerContainer])
        
        outerContainer.addSubViews([question, container])
        
        question.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(0))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        container.snp.makeConstraints({
            $0.top.equalTo(question.snp.bottom).offset(StaticSize.size(7))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalToSuperview()
        })
        
        container.addSubViews([text])
        
        text.snp.makeConstraints({
            $0.top.bottom.equalToSuperview().inset(StaticSize.size(10))
            $0.left.right.equalToSuperview().inset(StaticSize.size(8))
        })
    }
}
