//
//  ProfileMainView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ProfileMainView: UIView {
    lazy var title: UILabel = {
        let view = UILabel()
        view.font = .gotham(ofSize: StaticSize.size(22), weight: .bold)
        view.textColor = .lightGray
        view.adjustsFontSizeToFitWidth = true
        view.text = ModuleUserDefaults.getEmail() ?? ""
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.rowHeight = StaticSize.size(52)
        view.showsVerticalScrollIndicator = false
        view.register(ProfileMainCell.self, forCellReuseIdentifier: ProfileMainCell.reuseIdentifier)
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
        addSubViews([title, tableView])
        
        title.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(21))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(title.snp.bottom).offset(StaticSize.size(32))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalToSuperview()
        })
    }
}
