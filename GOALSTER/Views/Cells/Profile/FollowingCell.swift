//
//  FollowingCell.swift
//  GOALSTER
//
//  Created by Dan on 2/17/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class FollowingCell: UITableViewCell {
    static let reuseIdentifier = "FollowingCell"
    
    var index: Int? {
        didSet {
            topLine.isHidden = !(index == 0)
        }
    }
    var user: FeedUserFull? {
        didSet {
            titleLabel.text = user?.profile?.name
            subtitleLabel.text = user?.email
            followButton.user = user
        }
    }
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .medium)
        view.textColor = .ultraGray
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(12), weight: .medium)
        view.textColor = .ultraGray
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var followButton: FollowButton = {
        let view = FollowButton()
        return view
    }()
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .borderGray
        return view
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .borderGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setUp()
    }
    
    func setUp() {
        contentView.addSubViews([topLine, followButton, titleLabel, subtitleLabel, bottomLine])
        
        topLine.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(StaticSize.size(0.5))
        })
        
        followButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(8))
            $0.right.equalToSuperview()
            $0.width.equalTo(StaticSize.size(138))
            $0.height.equalTo(StaticSize.size(28))
        })
        
        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(12))
            $0.left.equalToSuperview()
            $0.right.equalTo(followButton.snp.left).offset(StaticSize.size(15))
        })
        
        subtitleLabel.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-StaticSize.size(7))
            $0.left.right.equalToSuperview()
        })
        
        bottomLine.snp.makeConstraints({
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(StaticSize.size(0.5))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
