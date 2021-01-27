//
//  ProfileBaseView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class BaseView: UIView {
    lazy var topBrush: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        view.isHidden = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(32), weight: .bold)
        label.textColor = .customTextDarkPurple
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var addButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "addButton"), for: .normal)
        view.isHidden = true
        return view
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
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
        super.addSubViews([topView, contentView])
        
        topView.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(Global.safeAreaTop() + StaticSize.size(50))
        })
        
        topView.addSubViews([topBrush, addButton, titleLabel])
        
        topBrush.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(5)
            $0.width.equalTo(45)
            $0.centerX.equalToSuperview()
        })
        
        addButton.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.bottom.equalToSuperview()
            $0.size.equalTo(StaticSize.size(32))
        })
        
        titleLabel.snp.makeConstraints({
            $0.center.equalTo(addButton)
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.right.equalTo(addButton.snp.left).offset(-StaticSize.size(15))
        })
        
        contentView.snp.makeConstraints({
            $0.top.equalTo(topView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-StaticSize.tabBarHeight)
        })
    }
    
    func addSubViews_(_ views: [UIView]) {
        contentView.addSubViews(views)
    }
}

