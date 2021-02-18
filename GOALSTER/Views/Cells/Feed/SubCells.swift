//
//  SubCells.swift
//  GOALSTER
//
//  Created by Dan on 2/16/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class FeedSphereCell: UICollectionViewCell {
    static let reuseIdentifier = "FeedSphereCell"
    
    var type: CellType? {
        didSet {
            setUp()
        }
    }
    var sphere: FeedUserSphere? {
        didSet {
            countLabel.text = String(sphere?.count ?? 0)
            titleLabel.text = sphere?.name?.localized
        }
    }
    var index: Int?
    
    lazy var countLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .semiBold)
        switch type {
        case .feed:
            view.textColor = .arcticWhite
        case .detail:
            view.textColor = .deepBlue
        default:
            break
        }
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        switch type {
        case .feed:
            view.font = .primary(ofSize: StaticSize.size(10), weight: .regular)
            view.textColor = .arcticWhite
        case .detail:
            view.font = .primary(ofSize: StaticSize.size(12), weight: .medium)
            view.textColor = .deepBlue
        default:
            break
        }
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [countLabel, titleLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = StaticSize.size(2)
        return view
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        switch type {
        case .feed:
            view.backgroundColor = .arcticWhite
            view.alpha = 0.5
            view.isHidden = index == 0
        case .detail:
            view.layer.cornerRadius = StaticSize.size(2)
            switch index {
            case 0:
                view.backgroundColor = .greatRed
            case 1:
                view.backgroundColor = .goodYellow
            case 2:
                view.backgroundColor = .calmGreen
            default:
                break
            }
        default:
            break
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setUp()
    }
    
    func setUp() {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        switch type {
        case .feed:
            contentView.addSubViews([stackView, line])
            
            stackView.snp.makeConstraints({
                $0.center.equalToSuperview()
            })
            
            line.snp.makeConstraints({
                $0.left.equalToSuperview()
                $0.width.equalTo(StaticSize.size(1))
                $0.centerY.equalToSuperview()
                $0.height.equalTo(StaticSize.size(32))
            })
        case .detail:
            contentView.addSubViews([line, stackView])
            
            line.snp.makeConstraints({
                $0.bottom.equalToSuperview()
                $0.left.right.equalToSuperview().inset(StaticSize.size(10))
                $0.height.equalTo(StaticSize.size(4))
            })
            
            stackView.snp.makeConstraints({
                $0.bottom.equalTo(line.snp.top).offset(-StaticSize.size(3))
                $0.centerX.equalToSuperview()
            })
        default: break
        }
    }
    
    enum CellType {
        case feed
        case detail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ReactionCell: UICollectionViewCell {
    static let reuseIdentifier = "ReactionCell"
    
    var userId: Int?
    var index: Int?
    var reaction: Reaction? {
        didSet {
            emojiLabel.text = reaction?.emoji
            countLabel.text = String(reaction?.count ?? 0)
        }
    }
    
    lazy var emojiLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(30), weight: .regular)
        return view
    }()
    
    lazy var countLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(14), weight: .regular)
        view.textColor = .ultraGray
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [emojiLabel, countLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setUp()
    }
    
    func setUp() {
        contentView.addSubViews([stackView])
        
        stackView.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GoalsReactionsCell: UITableViewCell {
    static let reuseIdentifier = "GoalsReactionsCell"
    lazy var reactionsDelegate = ReactionCollectionViewDelegate()
    
    var user: FeedUserFull? {
        didSet {
            reactionsDelegate.reactions = user?.reactions ?? []
            reactionsDelegate.userId = user?.id
            reactionsCollection.reloadData()
        }
    }
    
    lazy var reactionsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        view.register(ReactionCell.self, forCellWithReuseIdentifier: ReactionCell.reuseIdentifier)
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        reactionsDelegate.collectionView = view
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setUp()
    }
    
    func setUp() {
        contentView.addSubViews([reactionsCollection])
        
        reactionsCollection.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(11))
            $0.bottom.equalToSuperview()
            $0.height.equalTo(StaticSize.size(50))
            $0.left.right.equalToSuperview().inset(StaticSize.size(7))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
