//
//  SphereModalView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class SphereModalView: UIView{
    lazy var topTitle: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(21), weight: .medium)
        view.textColor = .customTextDarkPurple
        view.text = "Choose sphere which goal applies to".localized
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(SphereCell.self, forCellReuseIdentifier: SphereCell.reuseIdentifier)
        view.delaysContentTouches = false
        view.separatorStyle = .none
        view.rowHeight = StaticSize.size(36)
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
        addSubViews([topTitle, tableView])
        
        topTitle.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(StaticSize.size(15))
        })
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(topTitle.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        })
    }
}

