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
    lazy var addView = AddGoalView()
    lazy var viewModel = AddGoalViewModel()
    lazy var disposeBag = DisposeBag()
    var superVc: DayViewController?
    var response: Bool? {
        didSet {
            superVc?.reload()
            dismiss(animated: true, completion: nil)
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
            if let user = selectedObserver {
                addView.fourthBottom.setTitle(user.email, for: .normal)
                addView.fourthBottom.setTitleColor(.customTextBlack, for: .normal)
                check()
            }
        }
    }
    
    var date: Date? {
        didSet {
            if date?.format() == Date().format(){
                addView.dateLabel.attributedText = ("Today".localized + " " + "\(date?.format(format: "d MMMM") ?? "")").underline(substring: "Today".localized)
            } else {
                addView.dateLabel.text = date?.format(format: "d MMMM")
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = addView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        addView.firstBottom.addTarget(self, action: #selector(openTimeModal), for: .touchUpInside)
        addView.secondBottom.addTarget(self, action: #selector(openSphereModal), for: .touchUpInside)
        addView.fourthBottom.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        addView.switchButton.addTarget(self, action: #selector(switchTapped(_:)), for: .touchUpInside)
        addView.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        addView.backButton.addTarget(self, action: #selector(dismissAnimated), for: .touchUpInside)
        addView.onFieldChange = onFieldChange
        
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableKeyboardDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardDisplay()
    }
    
    func bind(){
        viewModel.response.subscribe(onNext: { response in
            DispatchQueue.main.async {
                self.response = response
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func addTapped() {
        viewModel.addGoal(name: addView.thirdBottom.text, time: selectedTime, date: date, user: selectedObserver, isShared: addView.switchButton.isOn, sphere: selectedSphere?.0)
    }
    
    func onFieldChange() {
        check()
    }
    
    @objc func switchTapped(_ sender: UISwitch) {
        if sender.isOn && !ModuleUserDefaults.getIsPremium(){
            let vc = ProfilePremiumViewController()
            vc.showBackButton(onBack: {
                vc.removeTop()
                sender.isOn = false
                self.configureObservers(isOn: sender.isOn)
            })
            vc.setOnSuccess(onSuccess: {
                vc.removeTop()
                self.configureObservers(isOn: sender.isOn)
            })
            vc.premiumView.premiumVIew.backButton.isHidden = false
            openTop(vc: vc)
        } else {
            configureObservers(isOn: sender.isOn)
        }
    }
    
    func configureObservers(isOn: Bool) {
        addView.fourthStack.isHidden = !isOn
        check()
    }
    
    @objc func openSearch() {
        openTop(vc: SearchObserverViewController())
    }
    
    func check() {
        addView.addButton.isActive = selectedTime != nil && selectedSphere != nil && addView.thirdBottom.textColor != .lightGray && !(addView.switchButton.isOn && selectedObserver == nil)
    }
    
    @objc override func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            AppShared.sharedInstance.openedKeyboardSize = keyboardSize
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification){
    }
}
