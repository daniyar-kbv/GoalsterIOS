//
//  AboutAppView.swift
//  GOALSTER
//
//  Created by Dan on 2/15/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class AboutAppView: UIView {
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [contentView])
        view.axis = .vertical
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "about")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.textColor = .ultraGray
        view.numberOfLines = 0
        view.text = "The mission of the project is to inspire and draw inspiration from other users, learn the best habits of other people, help and motivate each other, improve yourself together, be a part of the same community, find like-minded people and go towards your goals together. Our app will help you achieve the best results and the best life.".localized
        view.textAlignment = .center
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(AboutCell.self, forCellReuseIdentifier: AboutCell.reuseIdentifier)
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.rowHeight = StaticSize.size(68)
        view.isScrollEnabled = false
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.snp.updateConstraints({
            $0.height.equalTo(CGFloat(tableView.numberOfRows(inSection: 0)) * tableView.rowHeight)
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    func setUp() {
        addSubViews([scrollView])
        
        scrollView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        scrollView.addSubViews([stackView])
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        })
        
        contentView.addSubViews([imageView, titleLabel, tableView])
        
        imageView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(25))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo((ScreenSize.SCREEN_WIDTH - StaticSize.size(30)) * (333 / 343))
        })
        
        titleLabel.snp.makeConstraints({
            $0.top.equalTo(imageView.snp.bottom).offset(StaticSize.size(16))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(StaticSize.size(26))
            $0.height.equalTo(CGFloat(tableView.numberOfRows(inSection: 0)) * tableView.rowHeight)
            $0.left.right.bottom.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
