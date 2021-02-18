//
//  ResultSmallVIew.swift
//  GOALSTER
//
//  Created by Daniyar on 9/2/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ResultSmallView: UIView {
    var result: Result? {
        didSet {
            let sphere = Sphere.findByName(name: result?.sphereName ?? "")
            icon.image = sphere.icon
            name.text = result?.sphereName?.localized
            number.text = "\(result?.number ?? 0)"
        }
    }
    
    var index: Int? {
        didSet {
            switch index {
            case 0:
                dot.tintColor = .greatRed
            case 1:
                dot.tintColor = .goodYellow
            case 2:
                dot.tintColor = .calmGreen
            default:
                break
            }
        }
    }
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .ultraPink
        return view
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(24), weight: .medium)
        label.textColor = .ultraGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var dot: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "dot")?.withRenderingMode(.alwaysTemplate)
        return view
    }()
    
    lazy var number: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(44), weight: .bold)
        label.textColor = .deepBlue
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([icon, name, dot, number])
        
        icon.snp.makeConstraints({
            $0.top.left.equalToSuperview()
            $0.size.equalTo(StaticSize.size(30))
        })
        
        name.snp.makeConstraints({
            $0.left.equalTo(icon.snp.right).offset(StaticSize.size(8))
            $0.centerY.equalTo(icon)
        })
        
        dot.snp.makeConstraints({
            $0.left.equalTo(name.snp.right).offset(StaticSize.size(8))
            $0.centerY.equalTo(name)
            $0.size.equalTo(StaticSize.size(8))
        })
        
        number.snp.makeConstraints({
            $0.top.equalTo(icon.snp.bottom).offset(StaticSize.size(8))
            $0.left.equalTo(name)
            $0.bottom.equalToSuperview()
        })
    }
}
