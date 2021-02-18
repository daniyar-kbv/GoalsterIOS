//
//  NotificationsView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class NotificationsView: UIView {
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.rowHeight = StaticSize.size(48)
        view.contentInset = UIEdgeInsets(top: StaticSize.size(40), left: 0, bottom: StaticSize.size(60), right: 0)
        view.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.reuseIdentifier)
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
