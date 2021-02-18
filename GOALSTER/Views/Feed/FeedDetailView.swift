//
//  UserDetailView.swift
//  GOALSTER
//
//  Created by Dan on 2/17/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class FeedDetailView: UIView {
    var set = false
    var user: FeedUserFull? {
        didSet {
            avatarView.kf.setImage(with: URL(string: user?.profile?.avatar ?? ""))
            followButton.user = user
            instagramButton.instagram = user?.profile?.instagramUsername
            dateLabel.text = "\("Goals for".localized) \(Date().format(format: "d MMMM, EEEE"))"
            spheresCollection.reloadData()
            setUp()
        }
    }
    
    lazy var topShadowContainer: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: StaticSize.size(5))
        view.layer.shadowRadius = StaticSize.size(10)
        view.layer.shadowOpacity = 0.07
        return view
    }()
    
    lazy var topContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .arcticWhite
        view.layer.cornerRadius = StaticSize.size(20)
        view.clipsToBounds = true
        return view
    }()
    
    lazy var backButton: BackButton = {
        let view = BackButton()
        view.setBackgroundImage(view.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        view.tintColor = .deepBlue
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(17), weight: .medium)
        label.textColor = .ultraGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = StaticSize.size(45)
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var followButton: FollowButton = {
        let view = FollowButton()
        view.snp.makeConstraints({
            $0.width.equalTo(StaticSize.size(138))
            $0.height.equalTo(StaticSize.size(28))
        })
        return view
    }()
    
    lazy var instagramButton: InstagramButton = {
        let view = InstagramButton()
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(12), weight: .medium)
        view.textColor = .ultraGray
        return view
    }()
    
    lazy var topStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [followButton, instagramButton, dateLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .leading
        return view
    }()
    
    lazy var spheresCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        view.register(FeedSphereCell.self, forCellWithReuseIdentifier: FeedSphereCell.reuseIdentifier)
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: GoalsTableView = {
        let view = GoalsTableView()
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addGradientBackground()
    }
    
    func setUp() {
        addSubViews([topShadowContainer, tableView])
        
        topShadowContainer.snp.makeConstraints({
            $0.top.equalToSuperview().offset(-StaticSize.size(20))
            $0.left.right.equalToSuperview()
        })
        
        topShadowContainer.addSubViews([topContainer])
        
        topContainer.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        topContainer.addSubViews([backButton, titleLabel, avatarView, topStack, spheresCollection])
        
        backButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(Global.safeAreaTop() + StaticSize.size(31.5))
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.size.equalTo(StaticSize.size(30))
        })
        
        titleLabel.snp.makeConstraints({
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        })
        
        avatarView.snp.makeConstraints({
            $0.top.equalTo(backButton.snp.bottom).offset(StaticSize.size(20))
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.size.equalTo(StaticSize.size(90))
        })
        
        topStack.snp.makeConstraints({
            $0.top.bottom.equalTo(avatarView)
            $0.left.equalTo(avatarView.snp.right).offset(StaticSize.size(13))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
        })
        
        spheresCollection.snp.makeConstraints({
            $0.top.equalTo(avatarView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(StaticSize.size(5))
            $0.height.equalTo(StaticSize.size(46))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(12))
        })

        tableView.snp.makeConstraints({
            $0.top.equalTo(topShadowContainer.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        })
    }
}

class FollowButton: UIButton {
    lazy var viewModel = FollowViewModel()
    var onTap: ((_ user: FeedUserFull?)->())?
    var user: FeedUserFull? {
        didSet {
            isActive = user?.isFollowing
        }
    }
    var isActive: Bool? {
        didSet {
            setTitle((isActive ?? false) ? "Unfollow".localized : "Follow".localized, for: .normal)
            setTitleColor((isActive ?? false) ? .deepBlue : .arcticWhite, for: .normal)
            backgroundColor = (isActive ?? false) ? .clear : .deepBlue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = StaticSize.size(5)
        layer.borderWidth = StaticSize.size(1)
        layer.borderColor = UIColor.deepBlue.cgColor
        
        titleLabel?.font = .primary(ofSize: StaticSize.size(13), weight: .regular)
        
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc func tapped() {
        guard let userId = user?.id else { return }
        onTap?(user)
        isActive?.toggle()
        viewModel.follow(userId: userId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
