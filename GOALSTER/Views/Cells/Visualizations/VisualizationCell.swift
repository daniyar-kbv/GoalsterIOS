//
//  VisualizationCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/19/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class VisualizationCell: UICollectionViewCell {
    static let reuseIdentifier = "VisualizationCell"
    var onTap: ((_ visualizations: [Visualization]?, _ index: Int)->())?
    var onDelete: ((_ id: Int?)->())?
    var index: Int?
    var sphere: SphereVisualization? {
        didSet {
            switch index {
            case 0:
                bottomLine.backgroundColor = .greatRed
            case 1:
                bottomLine.backgroundColor = .goodYellow
            case 2:
                bottomLine.backgroundColor = .calmGreen
            default:
                break
            }
            title.text = sphere?.name?.localized
            collection.reloadData()
        }
    }
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.layer.cornerRadius = StaticSize.size(2.5)
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(24), weight: .medium)
        label.textColor = .darkBlack
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(VisualizationSmallCell.self, forCellWithReuseIdentifier: VisualizationSmallCell.reuseIdentifier)
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
        addSubViews([collection])
        
        collection.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview()
        })
        
        collection.addSubViews([title, bottomLine])
        
        title.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(StaticSize.size(26))
        })
        
        bottomLine.snp.makeConstraints({
            $0.top.equalTo(title.snp.bottom).offset(StaticSize.size(2))
            $0.left.equalToSuperview().offset(StaticSize.size(26))
            $0.width.equalTo(StaticSize.size(150))
            $0.height.equalTo(StaticSize.size(5))
        })
    }
}

extension VisualizationCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sphere?.visualizations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisualizationSmallCell.self.reuseIdentifier, for: indexPath) as! VisualizationSmallCell
        if let imageUrl = URL(string: sphere?.visualizations?[indexPath.row].image ?? "") {
            cell.image.kf.setImage(with: imageUrl)
        }
        cell.text.text = sphere?.visualizations?[indexPath.row].annotation ?? ""
        cell.visualizationId = sphere?.visualizations?[indexPath.row].id
        cell.onDelete = onDelete
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let onTap = onTap {
            onTap(sphere?.visualizations, indexPath.row)
        }
    }
}

extension VisualizationCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: StaticSize.size(162), height: StaticSize.size(190))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: StaticSize.size(46), left: StaticSize.size(20), bottom: 0, right: StaticSize.size(20))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return StaticSize.size(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return StaticSize.size(0)
    }
}
