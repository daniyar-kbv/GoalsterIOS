//
//  SearchObserverView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class SearchObserverView: UIView {
    lazy var topBrush: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    lazy var backButton: BackButton = {
        let view = BackButton()
        return view
    }()
    
    lazy var titleLabel: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.text = "Observer addition".localized
        view.font = .primary(ofSize: StaticSize.size(21), weight: .medium)
        view.textColor = .deepBlue
        return view
    }()
    
    lazy var searchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = StaticSize.size(5)
        view.layer.borderColor = UIColor.borderGray.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "close"), for: .normal)
        return view
    }()
    
    lazy var searchField: UITextField = {
        let view = UITextField()
        view.adjustsFontSizeToFitWidth = true
        view.placeholder = "Enter observer's E-mail".localized
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.textColor = .ultraGray
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(SearchObserverCell.self, forCellReuseIdentifier: SearchObserverCell.reuseIdentifier)
        view.rowHeight = StaticSize.size(40)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: StaticSize.size(100), right: 0)
        return view
    }()
    
    lazy var tableTopLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var addButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Add".localized, for: .normal)
        view.isActive = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([topBrush, backButton, titleLabel, searchView, tableView, addButton])
        
        topBrush.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(5)
            $0.width.equalTo(45)
            $0.centerX.equalToSuperview()
        })
        
        backButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(25))
            $0.left.equalToSuperview().offset(StaticSize.size(10))
            $0.size.equalTo(StaticSize.size(30))
        })
        
        titleLabel.snp.makeConstraints({
            $0.left.equalTo(backButton.snp.right).offset(StaticSize.size(15))
            $0.top.equalToSuperview().offset(StaticSize.size(30))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
        })
        
        searchView.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(StaticSize.size(24))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.size(36))
        })
        
        searchView.addSubViews([closeButton, searchField])
        
        closeButton.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(3))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(30))
        })
        
        searchField.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(11))
            $0.right.equalTo(closeButton.snp.left).offset(-StaticSize.size(11))
            $0.centerY.equalToSuperview()
        })
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(searchView.snp.bottom).offset(StaticSize.size(25))
            $0.left.right.bottom.equalToSuperview()
        })
        
        addButton.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
}
