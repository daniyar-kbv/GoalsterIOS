//
//  CalendarSmallCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/15/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class CalendarSmallCell: UICollectionViewCell {
    static let reuseIdentifier = "CalendarSmallCell"
    lazy var selectedDate: Date? = Date()
    
    var isToday = false {
        didSet {
            weekDayLabel.textColor = isToday ? .customTextDarkPurple : .lightGray
            numberLabel.textColor = isToday ? .customTextDarkPurple : .lightGray
        }
    }
    var isActive = false {
        didSet {
            container.backgroundColor = isActive ? .customCalendarPurple : .clear
            weekDayLabel.textColor = isActive ? .white : .lightGray
            numberLabel.textColor = isActive ? .white : .lightGray
            if isActive{
                weekDayLabel.textColor = .white
                numberLabel.textColor = .white
            } else if !isActive && isToday {
                weekDayLabel.textColor = .customTextDarkPurple
                numberLabel.textColor = .customTextDarkPurple
            } else {
                weekDayLabel.textColor = .lightGray
                numberLabel.textColor = .lightGray
            }
        }
    }
    var date: Date? {
        didSet {
            weekDayLabel.text = date?.getDayOfWeek()?.toStr ?? ""
            numberLabel.text = date?.format(format: "dd")
            isToday = date?.format() == Date().format()
            isActive = date?.format() == selectedDate?.format()
        }
    }
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = StaticSize.size(10)
        return view
    }()
    
    lazy var weekDayLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(14), weight: .bold)
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(15), weight: .bold)
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstDot: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "dot")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .customGoalRed
        return view
    }()
    
    lazy var secondDot: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "dot")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .customGoalYellow
        return view
    }()
    
    lazy var thirdDot: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "dot")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .customGoalGreen
        return view
    }()
    
    lazy var dotsStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [firstDot, secondDot, thirdDot])
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.spacing = StaticSize.size(3)
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
        addSubViews([container])
        
        container.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(StaticSize.size(6))
        })
        
        container.addSubViews([weekDayLabel, numberLabel, dotsStack])
        
        weekDayLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(7))
            $0.left.right.equalToSuperview().inset(StaticSize.size(5))
        })
        
        numberLabel.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-StaticSize.size(19))
            $0.left.right.equalToSuperview().inset(StaticSize.size(5))
        })
        
        dotsStack.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-StaticSize.size(7))
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isActive = false
        isToday = false
        setDots(false, false, true)
    }
}
