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
                dot.tintColor = .customGoalRed
            case 1:
                dot.tintColor = .customGoalYellow
            case 2:
                dot.tintColor = .customGoalGreen
            default:
                break
            }
            title.text = sphere?.name ?? ""
            collection.reloadData()
        }
    }
    
    lazy var dot: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "dot")?.withRenderingMode(.alwaysTemplate)
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(24), weight: .medium)
        label.textColor = .customTextBlack
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
        
        collection.addSubViews([dot, title])
        
        dot.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(19))
            $0.left.equalToSuperview().offset(StaticSize.size(26))
            $0.size.equalTo(StaticSize.size(8))
        })
        
        title.snp.makeConstraints({
            $0.left.equalTo(dot.snp.right).offset(StaticSize.size(5))
            $0.centerY.equalTo(dot)
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
        return CGSize(width: StaticSize.size(162), height: StaticSize.size(195))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: StaticSize.size(41), left: StaticSize.size(20), bottom: 0, right: StaticSize.size(20))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return StaticSize.size(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return StaticSize.size(0)
    }
}
