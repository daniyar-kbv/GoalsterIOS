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
    
    var onChange: ((_ sender: UISwitch)->())?
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(17), weight: .medium)
        label.textColor = .ultraGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var switchButton: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        view.onTintColor = .ultraPink
        view.tintColor = .arcticWhite
        view.addTarget(self, action: #selector(onSwitch(_:)), for: .valueChanged)
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
            onChange(sender)
        }
    }
    
    func setUp() {
        contentView.addSubViews([switchButton, title])
        
        switchButton.snp.makeConstraints({
            $0.right.centerY.equalToSuperview()
            $0.width.equalTo(StaticSize.size(52))
            $0.height.equalTo(StaticSize.size(32))
        })
        
        title.snp.makeConstraints({
            $0.left.centerY.equalToSuperview()
            $0.right.equalTo(switchButton.snp.left).offset(-StaticSize.size(5))
        })
    }
}
