//
//  GoalsHeaderView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/16/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class GoalsHeaderCell: UITableViewCell {
    static let reuseIdentifier = "GoalsHeaderCell"
    
    var time: TimeOfTheDay?{
        didSet {
            switch time {
            case .morning:
                icon.image = UIImage(named: "morning")
                title.text = "Morning".localized
            case .day:
                icon.image = UIImage(named: "day")
                title.text = "Afternoon".localized
            case .evening:
                icon.image = UIImage(named: "evening")
                title.text = "Evening".localized
            default:
                break
            }
        }
    }
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(16), weight: .medium)
        label.textColor = .customTextBlack
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([icon, title])
        
        icon.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.top.bottom.equalToSuperview().inset(StaticSize.size(3))
            $0.size.equalTo(StaticSize.size(20))
        })
        
        title.snp.makeConstraints({
            $0.left.equalTo(icon.snp.right).offset(StaticSize.size(7))
            $0.centerY.equalTo(icon)
        })
    }
}
