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
    lazy var state: GoalsViewState = .initial
    lazy var viewModel = GoalsMainViewModel()
    lazy var tableVc = GoalsTableViewController()
    var response: TodayGoalsResponse? {
        didSet {
            goalsView.total = response?.total
            goalsView.clean()
            state = response?.goals?.goals ?? false ? .selected : .notSelected
            tableVc.dayView = goalsView.tableView
            tableVc.response = response?.goals
            tableVc.onReload = onReload
            add(tableVc)
            goalsView.finishSetUp(state: state)
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
        NotificationCenter.default.addObserver(self, selector: #selector(onWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        viewModel.view = view
        tableVc.viewModel.view = view
        
        bind()
        
        if let url = AppShared.sharedInstance.deeplinkURL {
            SceneDelegate.shareLinkHandling(url)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !ModuleUserDefaults.getIsLoggedIn() || !ModuleUserDefaults.getHasSpheres() {
            goalsView.finishSetUp(state: .initial)
        } else if ModuleUserDefaults.getHasSpheres() {
            viewModel.todayGoals()
        }
        
        switch state {
        case .initial:
            goalsView.initialAnimationView.play()
        case .notSelected:
            goalsView.notSelectedAnimationView.play()
        default:
            break
        }
    }
    
    @objc func buttonTapped() {
        if !ModuleUserDefaults.getIsLoggedIn() {
            present(AuthViewController(), animated: true, completion: nil)
        } else if !ModuleUserDefaults.getHasSpheres() {
            present(SpheresListViewController(), animated: true, completion: nil)
        } else {
            AppShared.sharedInstance.tabBarController.toTab(tab: 2)
        }
    }
    
    func bind() {
        AppShared.sharedInstance.hasSpheresSubject.subscribe(onNext: { hasSpheres in
            DispatchQueue.main.async {
                if hasSpheres{
                    self.state = .notSelected
                    self.goalsView.clean()
                    self.viewWillAppear(true)
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
        AppShared.sharedInstance.doneGoalResponse.subscribe(onNext: { response in
            DispatchQueue.main.async {
                self.viewModel.todayGoals(withSpinner: false)
            }
        }).disposed(by: disposeBag)
        viewModel.response.subscribe(onNext: { response in
            DispatchQueue.main.async {
                self.response = response
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func onWillEnterForegroundNotification(){
        switch state {
        case .initial:
            goalsView.initialAnimationView.play()
        case .notSelected:
            goalsView.notSelectedAnimationView.play()
        default:
            break
        }
    }
    
    func onReload() {
        viewWillAppear(true)
    }
}
