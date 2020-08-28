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
    lazy var topTitle: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(21), weight: .medium)
        view.textColor = .customTextDarkPurple
        view.text = "Change app's language".localized
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(LanguageCell.self, forCellReuseIdentifier: LanguageCell.reuseIdentifier)
        view.delaysContentTouches = false
        view.separatorStyle = .none
        view.rowHeight = StaticSize.size(36)
        return view
    }()
    
    lazy var button: CustomButton = {
        let view = CustomButton()
        view.setTitle("Choose".localized, for: .normal)
        view.isHidden = true
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
        addSubViews([topTitle, tableView, button])
        
        topTitle.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(StaticSize.size(15))
        })
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(topTitle.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        })
        
        button.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
}
