//
//  NotificationsCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class NotificationCell: UITableViewCell {
    static let reuseIdentifier = "NotificationCell"
    
    var onChange: ((_ isOn: Bool)->())?
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(20), weight: .medium)
        label.textColor = .customTextBlack
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var switchButton: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        view.addTarget(self, action: #selector(onSwitch(_:)), for: .valueChanged)
        return view
    }()
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.isHidden = true
        return view
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onSwitch(_ sender: UISwitch) {
        if let onChange = onChange {
            onChange(sender.isOn)
        }
    }
    
    func setUp() {
        addSubViews([switchButton, title, topLine, bottomLine])
        
        switchButton.snp.makeConstraints({
            $0.right.centerY.equalToSuperview()
            $0.width.equalTo(StaticSize.size(52))
            $0.height.equalTo(StaticSize.size(32))
        })
        
        title.snp.makeConstraints({
            $0.left.centerY.equalToSuperview()
            $0.right.equalTo(switchButton.snp.left).offset(-StaticSize.size(5))
        })
        
        topLine.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
        })
        
        bottomLine.snp.makeConstraints({
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
        })
    }
}
