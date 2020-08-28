//
//  VisualizationSmallCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/19/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class VisualizationSmallCell: UICollectionViewCell {
    static let reuseIdentifier = "VisualizationSmallCell"
    
    lazy var image: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = StaticSize.size(17)
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var text: UILabel = {
        let view = UILabel()
        view.font = .gotham(ofSize: StaticSize.size(12), weight: .book)
        view.textColor = .customTextBlack
        view.numberOfLines = 2
        view.adjustsFontSizeToFitWidth = true
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
        addSubViews([image, text])
        
        image.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.size.equalTo(StaticSize.size(150))
        })
        
        text.snp.makeConstraints({
            $0.top.equalTo(image.snp.bottom).offset(StaticSize.size(4))
            $0.left.right.bottom.equalToSuperview()
        })
    }
}
