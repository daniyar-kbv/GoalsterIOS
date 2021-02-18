//
//  FollowingView.swift
//  GOALSTER
//
//  Created by Dan on 2/17/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class FollowingView: UIView {
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = StaticSize.size(67)
        view.separatorStyle = .none
        view.register(FollowingCell.self, forCellReuseIdentifier: FollowingCell.reuseIdentifier)
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: StaticSize.size(25), left: 0, bottom: 0, right: 0)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    func setUp() {
        addSubViews([tableView])
        
        tableView.snp.makeConstraints({
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
