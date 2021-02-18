//
//  GoalsTableView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class GoalsTableView: UIView {
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(GoalsHeaderCell.self, forCellReuseIdentifier: GoalsHeaderCell.reuseIdentifier)
        view.register(GoalsCell.self, forCellReuseIdentifier: GoalsCell.reuseIdentifier)
        view.register(GoalsReactionsCell.self, forCellReuseIdentifier: GoalsReactionsCell.reuseIdentifier)
        view.backgroundColor = .clear
        view.estimatedRowHeight = StaticSize.size(70)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    func setUp() {
        addSubViews([tableView])
        
        tableView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
