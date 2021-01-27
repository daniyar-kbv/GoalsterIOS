//
//  SphereCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/16/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class SphereCell: UITableViewCell {
    static let reuseIdentifier = "SphereCell"
    
    var index: Int? {
        didSet {
            switch index {
            case 0:
                dot.tintColor = .customGoalRed
            case 1:
                dot.tintColor = .customGoalYellow
            case 2:
                dot.tintColor = .customGoalGreen
            default:
                break
            }
        }
    }
    
    var sphere: SelectedSphere? {
        didSet {
            title.text = sphere?.sphere?.localized
            icon.image = Sphere.findByName(name: sphere?.sphere ?? "").icon_active.image
        }
    }
    
    var isActive = false {
        didSet {
            radio.image = UIImage(named: "radio_purple_\(isActive ? "active" : "inactive")")
        }
    }
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .customActivePurple
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(16), weight: .medium)
        label.textColor = .customTextDarkPurple
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var dot: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "dot")?.withRenderingMode(.alwaysTemplate)
        return view
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
        addSubViews([icon, title, dot, radio])
        
        icon.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(30))
        })
        
        title.snp.makeConstraints({
            $0.left.equalTo(icon.snp.right).offset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
        })
        
        dot.snp.makeConstraints({
            $0.left.equalTo(title.snp.right).offset(StaticSize.size(8))
            $0.size.equalTo(StaticSize.size(8))
            $0.centerY.equalToSuperview()
        })
        
        radio.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.size.equalTo(StaticSize.size(24))
            $0.centerY.equalToSuperview()
        })
    }
}
