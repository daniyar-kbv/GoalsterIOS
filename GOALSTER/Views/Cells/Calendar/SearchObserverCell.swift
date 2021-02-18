//
//  SearchObserverCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class SearchObserverCell: UITableViewCell {
    static let reuseIdentifier = "SearchObserverCell"
    
    var user: User? {
        didSet {
            title.text = user?.email
        }
    }
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        label.textColor = .ultraGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .borderGray
        view.isHidden = true
        return view
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .borderGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([topLine, title, bottomLine])
        
        topLine.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.top.equalToSuperview()
            $0.height.equalTo(0.5)
        })
        
        title.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
        })
        
        bottomLine.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        })
    }
}
