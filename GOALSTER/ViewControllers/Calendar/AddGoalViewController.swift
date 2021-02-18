//
//  AddGoalViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/16/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AddGoalViewController: UIViewController {
    enum ViewType {
        case add
        case update
    }
    lazy var addView = AddGoalView()
    lazy var viewModel = AddGoalViewModel()
    lazy var disposeBag = DisposeBag()
    var type: ViewType
    var superVc: UIViewController?
    var goal: Goal? {
        didSet {
            selectedTime = goal?.time
            if let sphereNumber = goal?.sphere?.rawValue,  let selectedSphere = ModuleUserDefaults.getSpheres()?[sphereNumber - 1] {
                self.selectedSphere = (selectedSphere, sphereNumber - 1)
            }
            selectedObserver = goal?.observer
            if let index = (addView.inputStack.arrangedSubviews as? [InputView])?.firstIndex(where: { $0.viewType == .goal }) {
                (addView.inputStack.arrangedSubviews as? [InputView])?[index].textView?.isEmpty = false
                (addView.inputStack.arrangedSubviews as? [InputView])?[index].textView?.text = goal?.name
            }
            addView.publicSwitchView.switchButton.isOn = goal?.isPublic ?? false
            addView.observationSwitchView.switchButton.isOn = goal?.observer != nil
//            observationSwitchTapped(addView.observationSwitchView.switchButton)
            configureObservers(isOn: selectedObserver != nil)
        }
    }
    var response: Goal? {
        didSet {
            (superVc as? DayViewController)?.reload()
            dismiss(animated: true, completion: nil)
            if date?.format() == Date().format(), let goal = response {
                let goalsStatus = ModuleUserDefaults.getGoalsStatus() == nil ?
                    GoalsStatus(
                        date: Date(),
                        goals: TodayGoalsResponse(
                            total: nil,
                            goals: GoalsResponse(goals: true, morning: [], day: [], evening: [])
                        )
                    ) :
                    ModuleUserDefaults.getGoalsStatus()!
                switch response?.time {
                case .morning:
                    switch type{
                    case .add:
                        goalsStatus.goals?.goals?.morning?.append(goal)
                    case .update:
                        guard let index = goalsStatus.goals?.goals?.morning?.firstIndex(where: { goal.id == $0.id }), let goal = response else { return }
                        goalsStatus.goals?.goals?.morning?[index] = goal
                    }
                case .day:
                    switch type{
                    case .add:
                        goalsStatus.goals?.goals?.day?.append(goal)
                    case .update:
                        guard let index = goalsStatus.goals?.goals?.day?.firstIndex(where: { goal.id == $0.id }), let goal = response else { return }
                        goalsStatus.goals?.goals?.day?[index] = goal
                    }
                case .evening:
                    switch type{
                    case .add:
                        goalsStatus.goals?.goals?.evening?.append(goal)
                    case .update:
                        guard let index = goalsStatus.goals?.goals?.evening?.firstIndex(where: { goal.id == $0.id }), let goal = response else { return }
                        goalsStatus.goals?.goals?.evening?[index] = goal
                    }
                default:
                    break
                }
                goalsStatus.goals?.goals?.goals = true 
                AppShared.sharedInstance.goalsStatus = goalsStatus
            }
            if let localCalendar = AppShared.sharedInstance.localCalendar, let goal = response {
                let response = localCalendar.first(where: { $0.calendarItem?.date == date?.format() })?.goalsResponse
                response?.goals = true
                switch goal.time {
                case .morning:
                    switch type {
                    case .add:
                        if response?.morning != nil {
                            response?.morning?.append(goal)
                        } else {
                            response?.morning = [goal]
                        }
                    case .update:
                        guard let index = response?.morning?.firstIndex(where: { goal.id == $0.id }), let goal = self.response else { return }
                        response?.morning?[index] = goal
                    }
                case .day:
                    switch type {
                    case .add:
                        if response?.day != nil {
                            response?.day?.append(goal)
                        } else {
                            response?.day = [goal]
                        }
                    case .update:
                        guard let index = response?.day?.firstIndex(where: { goal.id == $0.id }), let goal = self.response else { return }
                        response?.day?[index] = goal
                    }
                case .evening:
                    switch type {
                    case .add:
                        if response?.evening != nil {
                            response?.evening?.append(goal)
                        } else {
                            response?.evening = [goal]
                        }
                    case .update:
                        guard let index = response?.evening?.firstIndex(where: { goal.id == $0.id }), let goal = self.response else { return }
                        response?.evening?[index] = goal
                    }
                default:
                    break
                }
                let calendarItemGoals = localCalendar.first(where: { $0.calendarItem?.date == date?.format() })?.calendarItem?.goals
                switch goal.sphere {
                case .first:
                    calendarItemGoals?.first = true
                case .second:
                    calendarItemGoals?.second = true
                case .third:
                    calendarItemGoals?.third = true
                default:
                    break
                }
                AppShared.sharedInstance.localCalendar = localCalendar
            }
            if type == .update, let goal = response {
                (superVc as? GoalDetailViewController)?.goal = goal
            }
        }
    }
    
    var selectedTime: TimeOfTheDay? {
        didSet {
            addView.setTime(time: selectedTime!)
            check()
        }
    }
    var selectedSphere: (SelectedSphere, Int)? {
        didSet {
            addView.setSphere(sphere: (selectedSphere?.0)!, index: (selectedSphere?.1)!)
            check()
        }
    }
    
    var selectedObserver: User? {
        didSet {
            if let email = selectedObserver?.email {
                addView.observationInput.buttonInput.setText(text: email)
                check()
            }
        }
    }
    
    var date: Date? {
        didSet {
            if date?.format() == Date().format(){
                addView.dateLabel.text = "Today".localized + " " + "\(date?.format(format: "d MMMM") ?? "")"
            } else {
                addView.dateLabel.text = date?.format(format: "d MMMM")
            }
        }
    }
    
    required init(type: ViewType = .add) {
        self.type = type
        
        super.init(nibName: .none, bundle: .none)
        
        if type == .update {
            addView.addButton.setTitle("Save".localized, for: .normal)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = addView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inputViews = addView.inputStack.arrangedSubviews as? [InputView]
        inputViews?.first(where: { $0.viewType == .timeOfTheDay })?.buttonInput.addTarget(self, action: #selector(openTime), for: .touchUpInside)
        inputViews?.first(where: { $0.viewType == .sphere })?.buttonInput.addTarget(self, action: #selector(openSpheres), for: .touchUpInside)
        inputViews?.first(where: { $0.viewType == .goal })?.onChange = { object in
            self.check()
        }
        addView.observationInput.buttonInput.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        addView.observationSwitchView.switchButton.addTarget(self, action: #selector(observationSwitchTapped(_:)), for: .touchUpInside)
        addView.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        addView.onFieldChange = onFieldChange
        
        bind()
    }
    
    @objc func openTime() {
        AppShared.sharedInstance.modalSelectedTime = selectedTime
        let vc = TimeModalViewController(parentVc: self)
        openTop(vc: vc)
//        dismiss(animated: true, completion: {
//            UIApplication.topViewController()?.present(vc, animated: true)
//        })
    }
    
    @objc func openSpheres() {
        AppShared.sharedInstance.modalSelectedSphere = selectedSphere
        let vc = SphereModalViewController(parentVc: self)
        openTop(vc: vc)
//        dismiss(animated: true, completion: {
//            UIApplication.topViewController()?.present(vc, animated: true)
//        })
    }
    
    func bind(){
        viewModel.response.subscribe(onNext: { response in
            DispatchQueue.main.async {
                self.response = response
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func addTapped() {
        switch type {
        case .add:
            viewModel.addGoal(
                name: ((addView.inputStack.arrangedSubviews as? [InputView])?.first(where: { $0.viewType == .goal })?.getInput() as? PrimaryTextView)?.text,
                time: selectedTime,
                date: date,
                user: selectedObserver,
                isShared: addView.observationSwitchView.switchButton.isOn,
                sphere: selectedSphere?.0,
                isPublic: addView.publicSwitchView.switchButton.isOn
            )
        case .update:
            viewModel.updateGoal(
                goalId: goal?.id,
                name: ((addView.inputStack.arrangedSubviews as? [InputView])?.first(where: { $0.viewType == .goal })?.getInput() as? PrimaryTextView)?.text,
                time: selectedTime,
                date: date,
                user: selectedObserver,
                isShared: addView.observationSwitchView.switchButton.isOn,
                sphere: selectedSphere?.0,
                isPublic: addView.publicSwitchView.switchButton.isOn
            )
        }
    }
    
    func onFieldChange() {
        check()
    }
    
    @objc func observationSwitchTapped(_ sender: UISwitch) {
        if sender.isOn && !ModuleUserDefaults.getIsPremium(){
            let vc = ModalPremiumViewController(parentVc: self)
            vc.showBackButton(onBack: {
                vc.backToParent()
                sender.isOn = false
                self.configureObservers(isOn: sender.isOn)
            })
            vc.setOnSuccess(onSuccess: {
                vc.backToParent()
                self.configureObservers(isOn: sender.isOn)
            })
            openTop(vc: vc)
        } else {
            configureObservers(isOn: sender.isOn)
        }
    }
    
    func configureObservers(isOn: Bool) {
        addView.observationStack.isHidden = !isOn
        check()
    }
    
    @objc func openSearch() {
        let vc = SearchObserverViewController(parentVc: self)
        dismiss(animated: true, completion: {
            UIApplication.topViewController()?.present(vc, animated: true)
        })
    }
    
    func check() {
        addView.addButton.isActive =
            selectedTime != nil &&
            selectedSphere != nil &&
            !((addView.inputStack.arrangedSubviews as? [InputView])?.first(where: { $0.viewType == .goal })?.getInput().isEmpty ?? true) &&
            !(addView.observationSwitchView.switchButton.isOn && selectedObserver == nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
