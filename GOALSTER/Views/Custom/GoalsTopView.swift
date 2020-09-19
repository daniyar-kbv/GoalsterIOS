//
//  GoalsTopView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class GoalView: UIView {
    var index: Int
    var number = 0 {
        didSet {
            numberLabel.text = "\(number)"
        }
    }
    var color: UIColor = .customGoalRed {
        didSet {
            topLeftDot.tintColor = color
        }
    }
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    lazy var topLeftDot: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "dot")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .customGoalRed
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(32), weight: .book)
        label.textColor = UIColor.customTextDarkPurple.withAlphaComponent(0.5)
        label.text = "\(number)"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(12), weight: .book)
        label.textColor = .customTextDarkPurple
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = AppShared.sharedInstance.selectedSpheres?[index].sphere?.localized ?? ""
        return label
    }()
    
    required init(index: Int) {
        self.index = index
        
        super.init(frame: .zero)
        layer.cornerRadius = StaticSize.size(15)
        backgroundColor = .white
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([topLeftDot, numberLabel, nameLabel])
        topLeftDot.snp.makeConstraints({
            $0.top.left.equalToSuperview().offset(StaticSize.size(7))
            $0.size.equalTo(StaticSize.size(8))
        })
        
        numberLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        nameLabel.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(5))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(11))
        })
    }
}
