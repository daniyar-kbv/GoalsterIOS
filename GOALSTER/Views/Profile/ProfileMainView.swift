//
//  ProfileMainView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ProfileMainView: UIView {
    var vc: ProfileMainViewController
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(32), weight: .black)
        label.textColor = .deepBlue
        label.text = "Profile".localized
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var mainScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        return view
    }()

    lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [contentView])
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: StaticSize.size(100), trailing: 0)
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .arcticWhite
        view.layer.cornerRadius = StaticSize.size(15)
        return view
    }()
    
    lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .arcticWhite
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = StaticSize.size(60)
        view.layer.borderWidth = StaticSize.size(8)
        view.layer.borderColor = UIColor.arcticWhite.cgColor
        view.layer.masksToBounds = true
        view.kf.setImage(with: URL(string: AppShared.sharedInstance.profile?.avatar ?? ""))
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(22), weight: .medium)
        view.textColor = .deepBlue
        view.text = AppShared.sharedInstance.profile?.name
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.rowHeight = StaticSize.size(72)
        view.showsVerticalScrollIndicator = false
        view.register(ProfileMainCell.self, forCellReuseIdentifier: ProfileMainCell.reuseIdentifier)
        return view
    }()
    
    required init(vc: ProfileMainViewController) {
        self.vc = vc
        
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addGradientBackground()
    }
    
    func setUp() {
        addSubViews([mainScrollView, titleLabel])
        
        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(Global.safeAreaTop())
            $0.left.equalToSuperview().offset(StaticSize.size(15))
        })
        
        mainScrollView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        mainScrollView.addSubViews([mainStackView])
        
        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        })
        
        contentView.addSubViews([container, avatarView, nameLabel, tableView])
        
        container.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(112) + Global.safeAreaTop())
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(StaticSize.fieldHeight)
        })
        
        avatarView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(52) + Global.safeAreaTop())
            $0.centerX.equalToSuperview()
            $0.size.equalTo(StaticSize.size(120))
        })
        
        nameLabel.snp.makeConstraints({
            $0.top.equalTo(avatarView.snp.bottom).offset(StaticSize.size(13))
            $0.centerX.equalToSuperview()
        })
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(nameLabel.snp.bottom).offset(StaticSize.size(24))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(CGFloat(vc.cellTypes.count) * tableView.rowHeight)
            $0.bottom.equalToSuperview().offset(-(StaticSize.tabBarHeight + StaticSize.size(15)))
        })
    }
}
