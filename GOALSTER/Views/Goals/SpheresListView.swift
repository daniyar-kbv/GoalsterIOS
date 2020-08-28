//
//  SpheresListView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class SpheresListView: UIView {
    lazy var topBrush: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    lazy var topText: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(21), weight: .medium)
        view.textColor = .customTextDarkPurple
        view.text = "Choose 3 spheres\nfor next 30 days".localized
        return view
    }()
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(13), weight: .light)
        label.textColor = .customTextDarkPurple
        label.text = "It might be changed in settings".localized
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = StaticSize.size(55)
        view.showsVerticalScrollIndicator = false
        view.register(SpheresListCell.self, forCellReuseIdentifier: SpheresListCell.reuseIdentifier)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: StaticSize.size(100), right: 0)
        view.separatorStyle = .none
        return view
    }()
    
    lazy var nextButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Next".localized, for: .normal)
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
        addSubViews([topBrush, topText, topLabel, tableView, nextButton])
        
        topBrush.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(5)
            $0.width.equalTo(45)
            $0.centerX.equalToSuperview()
        })
        
        topText.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(23))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        topLabel.snp.makeConstraints({
            $0.top.equalTo(topText.snp.bottom)
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(topLabel.snp.bottom).offset(StaticSize.size(10))
            $0.left.right.bottom.equalToSuperview()
        })
        
        nextButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
}
