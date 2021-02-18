//
//  DayView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/15/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class DayView: UIView {
    var state: CalendarViewState = .notSelected
    var isObserved = false
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
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
        view.setTitle("Month".localized, for: .normal)
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
    
    lazy var calendarCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.collectionViewLayout = layout
        view.showsHorizontalScrollIndicator = false
        view.register(CalendarSmallCell.self, forCellWithReuseIdentifier: CalendarSmallCell.reuseIdentifier)
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 0, left: StaticSize.size(10), bottom: 0, right: StaticSize.size(10))
        return view
    }()
    
    lazy var notSelectedAnimationView: AnimationView = {
        let view = AnimationView(name: "calendar_animation")
        view.loopMode = .loop
        view.backgroundBehavior = .pauseAndRestore
        return view
    }()
    
    lazy var bottomTextView: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.textColor = .ultraGray
        view.textAlignment = .center
        view.text = "You had not add goals\nfor this day".localized
        view.numberOfLines = 0
        return view
    }()
    
    lazy var button: CustomButton = {
        let view = CustomButton()
        view.setTitle("Add".localized, for: .normal)
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        label.textColor = .deepBlue
        label.textAlignment = .center
        label.text = "Today".localized + " " + "\(Date().format(format: "d MMMM"))"
        return label
    }()
    
    lazy var tableView: GoalsTableView = {
        let view = GoalsTableView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews([contentView])
        
        contentView.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-StaticSize.tabBarHeight)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addGradientBackground()
    }
    
    func finishSetUp(state: CalendarViewState){
        self.state = state
        
        switch state {
        case .notSelected:
            contentView.addSubViews([notSelectedAnimationView, bottomTextView, button, topView])
            
            notSelectedAnimationView.snp.makeConstraints({
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(StaticSize.size(200) + Global.safeAreaTop())
                $0.width.equalTo(StaticSize.size(250))
                $0.height.equalTo(StaticSize.size(250))
            })
            
            bottomTextView.snp.makeConstraints({
                $0.top.equalTo(notSelectedAnimationView.snp.bottom).offset(StaticSize.size(15))
                $0.centerX.equalToSuperview()
            })
            
            button.snp.makeConstraints({
                $0.top.equalTo(bottomTextView.snp.bottom).offset(StaticSize.size(24))
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
                $0.height.equalTo(StaticSize.buttonHeight)
            })
            
            topView.snp.makeConstraints({
                $0.top.right.left.equalToSuperview()
            })
            
            topView.addSubViews([calendarCollection])
            
            calendarCollection.snp.makeConstraints({
                $0.top.equalToSuperview().offset(StaticSize.size(4) + Global.safeAreaTop())
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(StaticSize.size(86))
            })
            
            notSelectedAnimationView.play()
        case .noGoals:
            contentView.addSubViews([notSelectedAnimationView, bottomTextView, button, topView, dateLabel])
            
            notSelectedAnimationView.snp.makeConstraints({
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(StaticSize.size(200) + Global.safeAreaTop())
                $0.width.equalTo(StaticSize.size(250))
                $0.height.equalTo(StaticSize.size(250))
            })
            
            bottomTextView.snp.makeConstraints({
                $0.top.equalTo(notSelectedAnimationView.snp.bottom).offset(StaticSize.size(15))
                $0.centerX.equalToSuperview()
            })
            
            button.snp.makeConstraints({
                $0.top.equalTo(bottomTextView.snp.bottom).offset(StaticSize.size(24))
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
                $0.height.equalTo(StaticSize.buttonHeight)
            })
            
            topView.snp.makeConstraints({
                $0.top.right.left.equalToSuperview()
            })
            
            topView.addSubViews([monthButton, calendarCollection, addButton])
            
            monthButton.snp.makeConstraints({
                $0.top.equalToSuperview().offset(StaticSize.size(4) + Global.safeAreaTop())
                $0.left.equalToSuperview().offset(StaticSize.size(15))
                $0.width.equalTo(StaticSize.size(128))
                $0.height.equalTo(StaticSize.size(28))
            })
            
            calendarCollection.snp.makeConstraints({
                $0.top.equalTo(monthButton.snp.bottom).offset(StaticSize.size(18))
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(StaticSize.size(86))
            })
            
            addButton.snp.makeConstraints({
                $0.top.equalToSuperview().offset(Global.safeAreaTop() + StaticSize.size(2))
                $0.right.equalToSuperview().offset(-StaticSize.size(15))
                $0.size.equalTo(StaticSize.size(32))
            })
            
            dateLabel.snp.makeConstraints({
                $0.left.equalToSuperview().offset(StaticSize.size(26))
                $0.top.equalTo(topView.snp.bottom).offset(StaticSize.size(11))
            })
            
            notSelectedAnimationView.play()
        case .goals:
            contentView.addSubViews([topView, dateLabel, tableView])
            
            topView.snp.makeConstraints({
                $0.top.right.left.equalToSuperview()
            })
            
            topView.addSubViews([monthButton, calendarCollection, addButton])
            
            monthButton.snp.makeConstraints({
                $0.top.equalToSuperview().offset(
                    isObserved ?
                        0 :
                        StaticSize.size(4) + Global.safeAreaTop()
                )
                $0.left.equalToSuperview().offset(StaticSize.size(15))
                $0.width.equalTo(StaticSize.size(128))
                $0.height.equalTo(StaticSize.size(28))
            })
            
            calendarCollection.snp.makeConstraints({
                $0.top.equalTo(monthButton.snp.bottom).offset(StaticSize.size(18))
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(StaticSize.size(86))
            })
            
            addButton.snp.makeConstraints({
                $0.top.equalToSuperview().offset(Global.safeAreaTop() + StaticSize.size(2))
                $0.right.equalToSuperview().offset(-StaticSize.size(15))
                $0.size.equalTo(StaticSize.size(32))
            })
            
            dateLabel.snp.makeConstraints({
                $0.left.equalToSuperview().offset(StaticSize.size(26))
                $0.top.equalTo(topView.snp.bottom).offset(StaticSize.size(11))
            })
            
            tableView.snp.makeConstraints({
                $0.top.equalTo(dateLabel.snp.bottom)
                $0.left.right.bottom.equalToSuperview()
            })
        }
    }
    
    func clean() {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        calendarCollection.snp.removeConstraints()
    }
}
