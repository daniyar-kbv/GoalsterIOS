//
//  GoalsMainView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class GoalsMainView: UIView {
    var state: GoalsViewState?
    var total: TotalGoals? {
        didSet {
            firstGoalView.number = total?.first ?? 0
            secondGoalView.number = total?.second ?? 0
            thirdGoalView.number = total?.third ?? 0
        }
    }
    
    lazy var goalsNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(14), weight: .book)
        label.textColor = .customLightGray
        label.isHidden = true
        label.text = "Number of complete goals".localized
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var firstGoalView: GoalView = {
        let view = GoalView(index: 0)
        view.color = .customGoalRed
        return view
    }()
    
    lazy var secondGoalView: GoalView = {
        let view = GoalView(index: 1)
        view.color = .customGoalYellow
        return view
    }()
    
    lazy var thirdGoalView: GoalView = {
        let view = GoalView(index: 2)
        view.color = .customGoalGreen
        return view
    }()
    
    lazy var goalsViewsStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [firstGoalView, secondGoalView, thirdGoalView])
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        return view
    }()
    
    lazy var initialAnimationView: AnimationView = {
        let view = AnimationView(name: "goals_not_selected_animation")
        view.loopMode = .loop
        return view
    }()
    
    lazy var notSelectedAnimationView: AnimationView = {
        let view = AnimationView(name: "goals_selected_animation")
        view.loopMode = .loop
        return view
    }()
    
    lazy var bottomTextView: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.textColor = .customLightGray
        view.textAlignment = .center
        return view
    }()
    
    lazy var tableView: GoalsTableView = {
        let view = GoalsTableView()
        return view
    }()
    
    lazy var button: CustomButton = {
        let view = CustomButton()
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
        addSubViews([goalsNumberLabel, goalsViewsStack])
        
        goalsNumberLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(18))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        goalsViewsStack.snp.makeConstraints({
            $0.top.equalTo(goalsNumberLabel.snp.bottom).offset(StaticSize.size(8))
            $0.left.right.equalToSuperview().inset(StaticSize.size(30))
        })
        
        for view in goalsViewsStack.arrangedSubviews{
            view.snp.makeConstraints({
                $0.size.equalTo(StaticSize.size(93))
            })
        }
    }
    
    func finishSetUp(state: GoalsViewState){
        self.state = state
        
        switch state {
        case .initial:
            addSubViews([initialAnimationView, bottomTextView, button])
            
            initialAnimationView.snp.makeConstraints({
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(StaticSize.size(110))
                $0.width.equalTo(StaticSize.size(350))
                $0.height.equalTo(StaticSize.size(350))
            })
            
            bottomTextView.snp.makeConstraints({
                $0.top.equalTo(initialAnimationView.snp.bottom).offset(-StaticSize.size(40))
                $0.centerX.equalToSuperview()
            })
            
            button.snp.makeConstraints({
                $0.top.equalTo(bottomTextView.snp.bottom).offset(StaticSize.size(10))
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
                $0.height.equalTo(StaticSize.buttonHeight)
            })
            
            button.setTitle("Choose".localized, for: .normal)
            bottomTextView.text = "Choose 3 spheres\nfor next 30 days".localized
            initialAnimationView.play()
        case .notSelected:
            addSubViews([notSelectedAnimationView, bottomTextView, button])
            
            notSelectedAnimationView.snp.makeConstraints({
                $0.centerX.equalToSuperview()
                $0.top.equalTo(goalsViewsStack.snp.bottom).offset(-StaticSize.size(20))
                $0.width.equalTo(StaticSize.size(350))
                $0.height.equalTo(StaticSize.size(350))
            })
            
            bottomTextView.snp.makeConstraints({
                $0.top.equalTo(notSelectedAnimationView.snp.bottom).offset(-StaticSize.size(40))
                $0.centerX.equalToSuperview()
            })
            
            button.snp.makeConstraints({
                $0.top.equalTo(bottomTextView.snp.bottom).offset(StaticSize.size(10))
                $0.left.right.equalToSuperview().inset(StaticSize.size(15))
                $0.height.equalTo(StaticSize.buttonHeight)
            })
            
            button.setTitle("Make a plan".localized, for: .normal)
            bottomTextView.text = "Make a plan\nfor next 30 days".localized
            goalsNumberLabel.isHidden = false
            notSelectedAnimationView.play()
        case .selected:
            addSubViews([tableView])
            
            tableView.snp.makeConstraints({
                $0.top.equalTo(goalsViewsStack.snp.bottom).offset(StaticSize.size(8))
                $0.left.right.bottom.equalToSuperview()
            })
            
            goalsNumberLabel.isHidden = false
        }
    }
    
    func clean() {
        for view in self.subviews {
            if ![goalsNumberLabel, goalsViewsStack].contains(view) {
                view.removeFromSuperview()
            }
        }
    }
}
