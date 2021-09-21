//
//  KnowledgeView.swift
//  GOALSTER
//
//  Created by Dan on 9/20/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

protocol KnowledgeViewDelegate: AnyObject {
    func refresh()
}

class KnowledgeView: UIView {
    weak var delegate: KnowledgeViewDelegate?
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(KnowledgeCell.self, forCellWithReuseIdentifier: String(describing: KnowledgeCell.self))
        view.contentInset = .init(top: Global.safeAreaTop(),
                                  left: StaticSize.size(16),
                                  bottom: StaticSize.tabBarHeight,
                                  right: StaticSize.size(16))
        view.backgroundColor = .clear
        view.refreshControl = refreshControll
        return view
    }()
    
    private lazy var refreshControll: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(32), weight: .black)
        view.textColor = .deepBlue
        view.text = "Knowledge.title".localized
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
        addSubViews([collectionView, titleLabel])
        
        collectionView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(Global.safeAreaTop())
            $0.left.right.equalToSuperview().inset(StaticSize.size(16))
        })
    }
    
    @objc private func refresh() {
        delegate?.refresh()
        refreshControll.endRefreshing()
    }
}
