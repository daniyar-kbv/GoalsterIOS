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

class NotificatonsViewController: ProfileBaseViewController {
    lazy var notificationsView = NotificationsView()
    lazy var viewModel = NotificationsViewModel()
    lazy var disposeBag = DisposeBag()
    
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
        
        setTitle("Notifications".localized)
        
        notificationsView.tableView.delegate = self
        notificationsView.tableView.dataSource = self
        
        bind()
        
        viewModel.getNotifications()
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
    
    func changeNotifications(_ isOn: Bool) {
        self.isOn = isOn
        viewModel.changeNotifications(isOn: isOn)
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
