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
    
    var index: Int? 
    
    var sphere: SelectedSphere? {
        didSet {
            title.text = sphere?.sphere?.localized
            icon.image = Sphere.findByName(name: sphere?.sphere ?? "").icon
        }
    }
    
    var isActive = false {
        didSet {
            radio.image = UIImage(named: "radio_\(isActive ? "active" : "inactive")")
        }
    }
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(18), weight: .medium)
        label.textColor = .deepBlue
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var radio: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "radio_inactive")
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
        addSubViews([icon, title, radio])
        
        icon.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(20))
        })
        
        title.snp.makeConstraints({
            $0.left.equalTo(icon.snp.right).offset(StaticSize.size(9))
            $0.centerY.equalToSuperview()
        })
        
        radio.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.size.equalTo(StaticSize.size(20))
            $0.centerY.equalToSuperview()
        })
    }
}
