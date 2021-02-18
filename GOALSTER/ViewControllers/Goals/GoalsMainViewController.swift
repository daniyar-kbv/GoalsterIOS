//
//  GoalsMainViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class GoalsMainViewController: BaseViewController {
    lazy var goalsView = GoalsMainView()
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = GoalsMainViewModel()
    lazy var didAppear = false
    lazy var state: GoalsViewState = .initial {
        didSet {
            guard goalsView.state != state else { return }
            goalsView.clean()
            goalsView.finishSetUp(state: state)
        }
    }
    lazy var tableVc: GoalsTableViewController = {
        let view = GoalsTableViewController()
        view.dayView = goalsView.tableView
        view.date = Date()
        view.onReload = {
            self.viewModel.todayGoals(withSpinner: false)
        }
        add(view)
        return view
    }()
    var response: TodayGoalsResponse? {
        didSet {
            state = response?.goals?.goals ?? false ? .selected : .notSelected
            
            tableVc.response = response?.goals
            AppShared.sharedInstance.totalGoals = response?.total
            ModuleUserDefaults.setGoalsStatus(object: GoalsStatus(date: Date(), goals: response))
        }
    }
    
    override func loadView() {
        super.loadView()
        
        setView(goalsView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Goals".localized)
        goalsView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        viewModel.view = view
        tableVc.viewModel.view = view
        
        bind()
        
        if let url = AppShared.sharedInstance.deeplinkURL {
            SceneDelegate.shareLinkHandling(url)
        }
        
        if !ModuleUserDefaults.getIsLoggedIn() || !ModuleUserDefaults.getHasSpheres() {
            goalsView.finishSetUp(state: .initial)
        } else if ModuleUserDefaults.getHasSpheres() {
            if let goalsStatus = AppShared.sharedInstance.goalsStatus {
                response = goalsStatus.goals
                viewModel.todayGoals(withSpinner: false)
            } else {
                viewModel.todayGoals(withSpinner: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if didAppear && ModuleUserDefaults.getIsLoggedIn() && ModuleUserDefaults.getHasSpheres() {
            viewModel.todayGoals(withSpinner: false)
        } else if !didAppear {
            didAppear = true
        }
    }
    
    @objc func buttonTapped() {
        if !ModuleUserDefaults.getIsLoggedIn() {
            present(FirstAuthViewController(), animated: true, completion: nil)
        } else if !ModuleUserDefaults.getHasSpheres() {
            present(SpheresListViewController(), animated: true, completion: nil)
        } else {
            AppShared.sharedInstance.tabBarController.toTab(tab: 2)
        }
    }
    
    func bind() {
        AppShared.sharedInstance.totalGoalsSubject.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.goalsView.total = object
            }
        }).disposed(by: disposeBag)
        AppShared.sharedInstance.goalsStatusSubject.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.state = object?.goals?.goals?.goals ?? false ? .selected : .notSelected
                self.tableVc.response = object?.goals?.goals
            }
        }).disposed(by: disposeBag)
        AppShared.sharedInstance.hasSpheresSubject.subscribe(onNext: { hasSpheres in
            DispatchQueue.main.async {
                if hasSpheres && self.state == .initial{
                    self.state = .notSelected
                } else if !hasSpheres && self.state != .initial {
                    self.state = .initial
                }
            }
        }).disposed(by: disposeBag)
        AppShared.sharedInstance.selectedSpheresSubject.subscribe(onNext: { spheres in
            DispatchQueue.main.async {
                self.goalsView.firstGoalView.name = spheres?[0].sphere?.localized ?? ""
                self.goalsView.secondGoalView.name = spheres?[1].sphere?.localized ?? ""
                self.goalsView.thirdGoalView.name = spheres?[2].sphere?.localized ?? ""
            }
        }).disposed(by: disposeBag)
        viewModel.response.subscribe(onNext: { response in
            DispatchQueue.main.async {
                self.response = response
            }
        }).disposed(by: disposeBag)
    }
    
    func onReload() {
        viewWillAppear(true)
    }
}
