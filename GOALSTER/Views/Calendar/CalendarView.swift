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
        view.backgroundColor = .customBackPink
        return view
    }()
    
    lazy var monthButton: UIButton = {
        let view = UIButton()
        view.setTitle("Week".localized, for: .normal)
        view.titleLabel?.font = .gotham(ofSize: StaticSize.size(14), weight: .book)
        view.setTitleColor(.customTextDarkPurple, for: .normal)
        view.setImage(UIImage(named: "arrowDown"), for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: StaticSize.size(3), left: StaticSize.size(5), bottom: 0, right: 0)
        view.semanticContentAttribute = UIApplication.shared
        .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
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
        
        topView.addSubViews([monthButton, daysStack])
        
        monthButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(4))
            $0.left.equalToSuperview().offset(StaticSize.size(15))
        })
        
        daysStack.snp.makeConstraints({
            $0.top.equalTo(monthButton.snp.bottom)
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.size(38))
            $0.bottom.equalToSuperview()
        })
        
        for i in 1..<8 {
            let view = UIView()
            let label: UILabel = {
                let label = UILabel()
                label.font = .gotham(ofSize: StaticSize.size(14), weight: .bold)
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
