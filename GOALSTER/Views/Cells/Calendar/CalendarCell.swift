//
//  CalendarCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {
    static let reuseIdentifier = "CalendarCell"
    
    var isIn = false {
        didSet {
            circle.tintColor = isIn ? .customCalendarPurple : .clear
            number.textColor = isIn ? .deepBlue : .lightGray
        }
    }
    
    var isToday = false {
        didSet {
            if isToday {
                circle.tintColor = .deepBlue
                number.textColor = .white
            }
        }
    }
    
    lazy var circle: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "circle")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .clear
        return view
    }()
    
    lazy var number: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.textColor = .lightGray
        view.textAlignment = .center
        return view
    }()

    lazy var firstDot: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "dot")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .greatRed
        return view
    }()
    
    lazy var secondDot: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "dot")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .goodYellow
        return view
    }()
    
    lazy var thirdDot: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "dot")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .calmGreen
        return view
    }()
    
    lazy var dotsStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [firstDot, secondDot, thirdDot])
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.spacing = StaticSize.size(3)
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([circle, dotsStack])
        
        circle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(3))
            $0.size.equalTo(StaticSize.size(37))
            $0.centerX.equalToSuperview()
        })
        
        circle.addSubViews([number])
        
        number.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(StaticSize.size(5))
        })
        
        dotsStack.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-StaticSize.size(3))
        })
        
        for dot in dotsStack.arrangedSubviews{
            dot.snp.makeConstraints({
                $0.size.equalTo(StaticSize.size(4))
            })
        }
    }
    
    func setDots(_ first: Bool, _ second: Bool, _ third: Bool){
        firstDot.isHidden = !first
        secondDot.isHidden = !second
        thirdDot.isHidden = !third
        dotsStack.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isIn = false
    }
}
