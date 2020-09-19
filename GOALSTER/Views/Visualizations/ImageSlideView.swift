//
//  ImageSlideView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ImageSliderView: UIView {
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .black
        view.isPagingEnabled = true
        view.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        return view
    }()
    
    lazy var pageNumberView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = StaticSize.size(3)
        view.backgroundColor = .darkGray
        return view
    }()
    
    lazy var pageNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(10), weight: .book)
        label.textColor = .white
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "crossPurple"), for: .normal)
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
        addSubViews([collection, pageNumberView, closeButton])
        
        collection.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        pageNumberView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(44))
            $0.left.equalToSuperview().offset(StaticSize.size(15))
        })
        
        pageNumberView.addSubViews([pageNumberLabel])
        
        pageNumberLabel.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(StaticSize.size(6))
        })
        
        closeButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(44))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.size.equalTo(StaticSize.size(20))
        })
    }
    
    func setNumber(number: Int, total: Int) {
        pageNumberLabel.text = "\(number)/\(total)"
    }
}
