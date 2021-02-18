//
//  BaseView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ProfileBaseView: UIView {
    
    lazy var backButton: BackButton = {
        let view = BackButton()
        view.setBackgroundImage(view.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        view.tintColor = .deepBlue
        return view
    }()
    
    lazy var rightButton: UIButton = {
        let view = UIButton()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(17), weight: .medium)
        label.textColor = .ultraGray
        label.adjustsFontSizeToFitWidth = true
        return label
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
    
    func setUp() {
        super.addSubViews([topView, contentView])
        
        topView.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(Global.safeAreaTop() + StaticSize.size(50))
        })
        
        topView.addSubViews([backButton, rightButton,titleLabel])
        
        backButton.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.bottom.equalToSuperview()
            $0.size.equalTo(StaticSize.size(30))
        })
        
        rightButton.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.bottom.equalToSuperview()
            $0.size.equalTo(StaticSize.size(30))
        })
        
        titleLabel.snp.makeConstraints({
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        })
        
        contentView.snp.makeConstraints({
            $0.top.equalTo(topView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
    }
    
    func addSubViews_(_ views: [UIView]) {
        contentView.addSubViews(views)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
