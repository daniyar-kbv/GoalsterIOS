//
//  LanguageCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/23/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class LanguageCell: UITableViewCell {
    
    static let reuseIdentifier = "LanguageCell"
    
    var isActive = false {
        didSet {
            radio.image = UIImage(named: "radio_purple_\(isActive ? "active" : "inactive")")
        }
    }
    
    var language: Language? = .none {
        didSet {
            switch language {
            case .en:
                title.text = "English"
            case .ru:
                title.text = "Русский"
            default:
                break
            }
        }
    }
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(16), weight: .medium)
        label.textColor = .customTextDarkPurple
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var radio: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "radio_purple_inactive")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([title, radio])
        
        title.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
        })
        
        radio.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.size.equalTo(StaticSize.size(24))
            $0.centerY.equalToSuperview()
        })
    }
}
