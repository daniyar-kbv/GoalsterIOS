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
    var visualizationId: Int?
    var onDelete: ((_ id: Int?)->())?
    
    lazy var image: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = StaticSize.size(17)
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var text: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(12), weight: .medium)
        view.textColor = .darkBlack
        view.numberOfLines = 2
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "delete"), for: .normal)
        view.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return view
    }()
    
    @objc func deleteTapped() {
        onDelete?(visualizationId)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([image, text, deleteButton])
        
        image.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(6))
            $0.left.right.equalToSuperview().inset(StaticSize.size(6))
            $0.size.equalTo(StaticSize.size(150))
        })
        
        text.snp.makeConstraints({
            $0.top.equalTo(image.snp.bottom).offset(StaticSize.size(4))
            $0.left.right.bottom.equalToSuperview().inset(StaticSize.size(6))
        })
        
        deleteButton.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.size.equalTo(StaticSize.size(20))
        })
    }
}
