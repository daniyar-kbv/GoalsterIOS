//
//  GoalsTopView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class GoalView: TappableButton {
    var index: Int
    var number = 0 {
        didSet {
            numberLabel.text = "\(number)"
        }
    }
    var color: UIColor = .greatRed {
        didSet {
            topLine.backgroundColor = color
        }
    }
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .calmGreen
        view.layer.cornerRadius = StaticSize.size(2.5)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(32), weight: .medium)
        label.textColor = UIColor.deepBlue.withAlphaComponent(0.5)
        label.text = "\(number)"
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(12), weight: .medium)
        label.textColor = .deepBlue
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = AppShared.sharedInstance.selectedSpheres?[index].sphere?.localized ?? ""
        label.isUserInteractionEnabled = false
        return label
    }()
    
    required init(index: Int) {
        self.index = index
        
        super.init(frame: .zero)
        
        switch index {
        case 0:
            number = ModuleUserDefaults.getTotalGoals()?.first ?? 0
        case 1:
            number = ModuleUserDefaults.getTotalGoals()?.second ?? 0
        case 2:
            number = ModuleUserDefaults.getTotalGoals()?.third ?? 0
        default:
            break
        }
        
        layer.cornerRadius = StaticSize.size(15)
        backgroundColor = .arcticWhite
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        setUp()
    }
    
    @objc func tapped() {
        guard let spheres = ModuleUserDefaults.getSpheres()?.map({ (key: Sphere.findByName(name: $0.sphere ?? ""), value: $0.sphere?.localized ?? "") }) else { return }
        viewContainingController()?.present(SpheresDescriptionViewController(spheres: spheres, fromProfile: true), animated: true)
    }
    
    func setUp() {
        addSubViews([topLine, numberLabel, nameLabel])
        topLine.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(7))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.size(5))
        })
        
        numberLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(27))
            $0.centerX.equalToSuperview()
        })
        
        nameLabel.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(5))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(11))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
