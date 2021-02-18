//
//  LaunchScreenViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class LaunchScreenViewController: UIViewController {
    lazy var launchView = LaunchScreenView()
    lazy var premiumViewModel = PremiumViewModel()
    lazy var disposeBag = DisposeBag()
    var timer: Timer?
    lazy var initialTimerValue: Double = 0.5
    lazy var timerValue: Double = initialTimerValue
    var needProfile = false
    
    override func loadView() {
        super.loadView()
        
        view = launchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runTimer()
        if ModuleUserDefaults.getIsLoggedIn() {
            APIManager.shared.connect(){ error, response in
                guard let response = response else { return }
                AppShared.sharedInstance.auth(response: response)
            }
        }
        if !ModuleUserDefaults.getIsPurchaseProcessed() {
            guard let identifier = ModuleUserDefaults.getLastPurchase()?.identifier, let date = ModuleUserDefaults.getLastPurchase()?.date, let productType = ModuleUserDefaults.getLastPurchase()?.productType else { return }
            premiumViewModel.premium(identifier: identifier, date: date, productType: productType)
        }
        
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addGradientBackground()
    }
    
    func bind() {
        AppShared.sharedInstance.profileSubject.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.needProfile = object == nil
            }
        }).disposed(by: disposeBag)
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if self.timerValue == 0{
                self.toMain()
                self.timer?.invalidate()
                return
            }
            self.timerValue -= 0.5
        }
    }
    
    func toMain() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        var vc: UIViewController
        if needProfile {
            vc = NeedProfileViewController()
        } else {
            vc = ModuleUserDefaults.getIsInitial() ? AppShared.sharedInstance.tabBarController : StartViewController()
        }
        if !(self.navigationController?.topViewController?.isKind(of: type(of: vc)) ?? false){
            self.navigationController?.pushViewController(vc, animated: false)
        }
        AppShared.sharedInstance.appLoaded = true
    }
}
