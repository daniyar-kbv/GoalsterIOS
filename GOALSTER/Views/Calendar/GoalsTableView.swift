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
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(12), weight: .bold)
        label.textColor = .customTextDarkPurple
        label.adjustsFontSizeToFitWidth = true
        label.attributedText = ("Today".localized + " " + "\(Date().format(format: "d MMMM"))").underline(substring: "Today".localized)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(GoalsHeaderCell.self, forCellReuseIdentifier: GoalsHeaderCell.reuseIdentifier)
        view.register(GoalsCell.self, forCellReuseIdentifier: GoalsCell.reuseIdentifier)
        view.backgroundColor = .clear
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
        addSubViews([dateLabel, tableView])
        
        dateLabel.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(StaticSize.size(30))
        })
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(dateLabel.snp.bottom).offset(StaticSize.size(10))
            $0.left.right.bottom.equalToSuperview()
        })
    }
}
