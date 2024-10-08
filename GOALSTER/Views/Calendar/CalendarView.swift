//
//  CalendarView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import JTAppleCalendar

class CalendarView: UIView {
    
    lazy var topView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowRadius = StaticSize.size(2.5)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.backgroundColor = .arcticPink
        return view
    }()
    
    lazy var monthButton: UIButton = {
        let view = UIButton()
        view.setTitle("Week".localized, for: .normal)
        view.titleLabel?.font = .primary(ofSize: StaticSize.size(13), weight: .regular)
        view.setTitleColor(.deepBlue, for: .normal)
        view.layer.borderWidth = StaticSize.size(1)
        view.layer.borderColor = UIColor.deepBlue.cgColor
        view.layer.cornerRadius = StaticSize.size(5)
        return view
    }()
    
    lazy var addButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "addButton"), for: .normal)
        return view
    }()
    
    lazy var daysStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()
    
    lazy var calendar: JTAppleCalendarView = {
        let view = JTAppleCalendarView()
        view.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.reuseIdentifier)
        view.register(CalendarHeaderCell.self, forSupplementaryViewOfKind: "", withReuseIdentifier: CalendarHeaderCell.reuseIdentifier)
        view.backgroundColor = .clear
        view.cellSize = StaticSize.size(51)
        view.minimumLineSpacing = 0
        view.minimumInteritemSpacing = 0
        view.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: StaticSize.tabBarHeight, right: 0)
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
        addSubViews([topView, calendar])
        
        topView.snp.makeConstraints({
            $0.top.right.left.equalToSuperview()
        })
        
        topView.addSubViews([monthButton, addButton, daysStack])
        
        monthButton.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.width.equalTo(StaticSize.size(128))
            $0.height.equalTo(StaticSize.size(28))
        })
        
        addButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(-StaticSize.size(2))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.size.equalTo(StaticSize.size(32))
        })
        
        daysStack.snp.makeConstraints({
            $0.top.equalTo(monthButton.snp.bottom)
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.size(38))
            $0.bottom.equalToSuperview()
        })
        
        for i in [2, 3, 4, 5, 6, 7, 1] {
            let view = UIView()
            let label: UILabel = {
                let label = UILabel()
                label.font = .primary(ofSize: StaticSize.size(14), weight: .bold)
                label.textColor = .lightGray
                label.adjustsFontSizeToFitWidth = true
                label.text = DayOfWeek(rawValue: i)?.toStr
                return label
            }()
            
            view.addSubViews([label])
            label.snp.makeConstraints({
                $0.center.equalToSuperview()
            })
            
            daysStack.addArrangedSubview(view)
        }
        
        calendar.snp.makeConstraints({
            $0.top.equalTo(topView.snp.bottom)
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalToSuperview().offset(StaticSize.tabBarHeight)
        })
    }
}
