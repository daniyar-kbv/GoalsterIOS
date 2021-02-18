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
        view.text = "Text about the 24Goals app and about Erkezhan. Description, goal, mission for example. Possibly long text".localized
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
        
        if tableView.frame.height < (CGFloat(tableView.numberOfRows(inSection: 0)) * tableView.rowHeight) {
            tableView.isScrollEnabled = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    func setUp() {
        addSubViews([imageView, titleLabel, tableView])
        
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
            $0.left.right.bottom.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
