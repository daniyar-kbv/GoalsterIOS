//
//  KnowledgeCell.swift
//  GOALSTER
//
//  Created by Dan on 9/20/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class KnowledgeCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = StaticSize.size(10)
        view.backgroundColor = .arcticWhite
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(14), weight: .bold)
        view.textColor = .deepBlue
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = StaticSize.size(10)
        layer.shadowOffset = .init(width: 0, height: StaticSize.size(5))
        layer.shadowOpacity = 0.07
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.addSubViews([imageView, titleLabel])
        
        imageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        titleLabel.snp.makeConstraints({
            $0.top.left.right.equalToSuperview().inset(StaticSize.size(10))
        })
    }
    
    func set(title: String, imageURL: URL?) {
        imageView.kf.setImage(with: imageURL)
        titleLabel.text = title
    }
}
