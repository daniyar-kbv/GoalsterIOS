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
        view.setTitle("Month".localized, for: .normal)
        view.titleLabel?.font = .gotham(ofSize: StaticSize.size(14), weight: .book)
        view.setTitleColor(.customTextDarkPurple, for: .normal)
        view.setImage(UIImage(named: "arrowDown"), for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: StaticSize.size(3), left: StaticSize.size(5), bottom: 0, right: 0)
        view.semanticContentAttribute = UIApplication.shared
        .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
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
        return view
    }()
    
    lazy var bottomTextView: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.textColor = .customLightGray
        view.textAlignment = .center
        view.text = "You had not add goals\nfor this day".localized 
        return view
    }()
    
    lazy var button: CustomButton = {
        let view = CustomButton()
        view.setTitle("Add".localized, for: .normal)
        return view
    }()
    
    lazy var tableView: GoalsTableView = {
        let view = GoalsTableView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func finishSetUp(state: CalendarViewState){
        self.state = state
        
        switch state {
        case .notSelected:
            addSubViews([notSelectedAnimationView, bottomTextView, button])
            
            notSelectedAnimationView.snp.makeConstraints({
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(StaticSize.size(150))
                $0.width.equalTo(StaticSize.size(250))
                $0.height.equalTo(StaticSize.size(250))
            })
            
            bottomTextView.snp.makeConstraints({
                $0.top.equalTo(notSelectedAnimationView.snp.bottom).offset(StaticSize.size(23))
                $0.centerX.equalToSuperview()
            })
            
            button.snp.makeConstraints({
                $0.top.equalTo(bottomTextView.snp.bottom).offset(StaticSize.size(10))
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
                $0.height.equalTo(StaticSize.buttonHeight)
            })
            
            notSelectedAnimationView.play()
        case .noGoals:
            addSubViews([notSelectedAnimationView, bottomTextView, button, topView])
            
            notSelectedAnimationView.snp.makeConstraints({
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(StaticSize.size(150))
                $0.width.equalTo(StaticSize.size(250))
                $0.height.equalTo(StaticSize.size(250))
            })
            
            bottomTextView.snp.makeConstraints({
                $0.top.equalTo(notSelectedAnimationView.snp.bottom).offset(StaticSize.size(23))
                $0.centerX.equalToSuperview()
            })
            
            button.snp.makeConstraints({
                $0.top.equalTo(notSelectedAnimationView.snp.bottom).offset(StaticSize.size(86))
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
                $0.height.equalTo(StaticSize.buttonHeight)
            })
            
            topView.snp.makeConstraints({
                $0.top.right.left.equalToSuperview()
            })
            
            topView.addSubViews([monthButton, calendarCollection])
            
            monthButton.snp.makeConstraints({
                $0.top.equalToSuperview().offset(StaticSize.size(4))
                $0.left.equalToSuperview().offset(StaticSize.size(15))
            })
            
            calendarCollection.snp.makeConstraints({
                $0.top.equalTo(monthButton.snp.bottom)
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(StaticSize.size(86))
            })
            
            notSelectedAnimationView.play()
        case .goals:
            addSubViews([topView, tableView])
            
            topView.snp.makeConstraints({
                $0.top.right.left.equalToSuperview()
            })
            
            topView.addSubViews([monthButton, calendarCollection])
            
            monthButton.snp.makeConstraints({
                $0.top.equalToSuperview().offset(StaticSize.size(4))
                $0.left.equalToSuperview().offset(StaticSize.size(15))
            })
            
            calendarCollection.snp.makeConstraints({
                $0.top.equalTo(monthButton.snp.bottom)
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(StaticSize.size(86))
            })
            
            tableView.snp.makeConstraints({
                $0.top.equalTo(topView.snp.bottom).offset(StaticSize.size(8))
                $0.left.right.bottom.equalToSuperview()
            })
        }
    }
    
    func clean() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
