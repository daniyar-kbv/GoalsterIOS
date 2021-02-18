//
//  LanguagesModalView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/23/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class LanguagesModalView: UIView{
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(LanguageCell.self, forCellReuseIdentifier: LanguageCell.reuseIdentifier)
        view.delaysContentTouches = false
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.rowHeight = StaticSize.size(42)
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
            $0.top.equalToSuperview().offset(StaticSize.size(45))
            $0.left.right.bottom.equalToSuperview()
        })
    }
}
