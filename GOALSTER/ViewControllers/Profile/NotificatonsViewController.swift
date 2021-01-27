//
//  NotificatonsViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class NotificatonsViewController: ProfileBaseViewController, UIGestureRecognizerDelegate {
    lazy var notificationsView = NotificationsView()
    lazy var viewModel = NotificationsViewModel()
    lazy var disposeBag = DisposeBag()
    var notificationsStatus: UNAuthorizationStatus = .notDetermined
    
    var success: Bool? {
        didSet {
            notificationsView.tableView.reloadData()
        }
    }
    
    var isOn: Bool? {
        didSet {
            notificationsView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        setView(notificationsView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.delegate = self
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = true
        
        setTitle("Notifications".localized)
        
        notificationsView.tableView.delegate = self
        notificationsView.tableView.dataSource = self
        
        bind()
        
        check()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func onWillEnterForegroundNotification(){
        check()
    }
    
    func check() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            self.notificationsStatus = settings.authorizationStatus
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    self.viewModel.getNotifications()
                case .denied:
                    self.isOn = false
                case .notDetermined:
                    print("not determined, ask user for permission now")
                @unknown default:
                    break
                }
            }
        })
    }
    
    func bind() {
        viewModel.success.subscribe(onNext: { success in
            DispatchQueue.main.async {
                self.success = success
            }
        }).disposed(by: disposeBag)
        viewModel.isOn.subscribe(onNext: { isOn in
            DispatchQueue.main.async {
                self.isOn = isOn
            }
        }).disposed(by: disposeBag)
    }
    
    func changeNotifications(_ sender: UISwitch) {
        if [UNAuthorizationStatus.authorized, UNAuthorizationStatus.provisional].contains(notificationsStatus) {
            self.isOn = sender.isOn
            viewModel.changeNotifications(isOn: sender.isOn)
        } else {
            sender.isOn.toggle()
            showAlertOk(title: "Allow push-notifications in settings".localized)
        }
    }
}

extension NotificatonsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseIdentifier, for: indexPath) as! NotificationCell
        switch indexPath.row {
        case 0:
            cell.title.text = "Push-notifications".localized
            cell.onChange = changeNotifications(_:)
            cell.switchButton.isOn = isOn ?? false
        default:
            break
        }
        return cell
    }
}
