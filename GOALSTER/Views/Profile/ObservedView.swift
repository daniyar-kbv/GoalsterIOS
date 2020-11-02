//
//  ObservedView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ObservedView: UIView {
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.rowHeight = StaticSize.size(48)
        view.contentInset = UIEdgeInsets(top: StaticSize.size(60), left: 0, bottom: StaticSize.size(60), right: 0)
        view.register(ObservedCell.self, forCellReuseIdentifier: ObservedCell.reuseIdentifier)
        view.delaysContentTouches = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([tableView])
        
        tableView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(15))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalToSuperview()
        })
    }
}
