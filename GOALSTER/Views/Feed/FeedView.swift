//
//  FeedViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/16/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class FeedView: UIView {
    var type: FeedViewController.VCType
    var isEmpty: Bool? {
        didSet {
            isEmpty ?? true ? setEmpty() : setUp()
        }
    }
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var noRecommendationsLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .medium)
        view.textColor = .strongGray
        view.text = "The recommendation list is empty".localized
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(FeedCell.self, forCellReuseIdentifier: FeedCell.reuseIdentifier)
        view.register(FeedPremiumCell.self, forCellReuseIdentifier: FeedPremiumCell.reuseIdentifier)
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: StaticSize.size(100), right: 0)
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.estimatedRowHeight = UITableView.automaticDimension
        view.delaysContentTouches = false
        return view
    }()
    
    lazy var emptyImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "emptyFeed")
        view.snp.makeConstraints({
            $0.width.equalTo(StaticSize.size(238.58))
            $0.height.equalTo(StaticSize.size(193.35))
        })
        return view
    }()
    
    lazy var emptyLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.textColor = .deepBlue
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text = "Empty feed text".localized
        view.snp.makeConstraints({
            $0.width.equalTo(ScreenSize.SCREEN_WIDTH - StaticSize.size(30))
        })
        return view
    }()
    
    lazy var bottomButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("To recommendations".localized, for: .normal)
        view.snp.makeConstraints({
            $0.width.equalTo(ScreenSize.SCREEN_WIDTH - StaticSize.size(30))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
        return view
    }()
    
    lazy var emptyStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [emptyImageView, emptyLabel, bottomButton])
        view.axis = .vertical
        view.alignment = .center
        view.setCustomSpacing(StaticSize.size(12.5), after: emptyImageView)
        view.setCustomSpacing(StaticSize.size(24), after: emptyLabel)
        return view
    }()
    
    required init(type: FeedViewController.VCType) {
        self.type = type
        
        super.init(frame: .zero)
        
        addSubViews([contentView])
        
        contentView.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-StaticSize.tabBarHeight)
        })
    }
    
    func setUp() {
        _ = contentView.subviews.map({ $0.removeFromSuperview() })
        
        contentView.addSubViews([tableView])
        
        tableView.snp.makeConstraints({
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(StaticSize.size(27))
        })
    }
    
    func setEmpty() {
        _ = contentView.subviews.map({ $0.removeFromSuperview() })
        switch type {
        case .following:
            contentView.addSubViews([emptyStack])
            
            emptyStack.snp.makeConstraints({
                $0.left.right.equalToSuperview()
                $0.centerY.equalToSuperview()
            })
        case .recommendations:
            contentView.addSubViews([noRecommendationsLabel])
            
            noRecommendationsLabel.snp.makeConstraints({
                $0.top.equalToSuperview().offset(StaticSize.size(100))
                $0.centerX.equalToSuperview()
            })
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
