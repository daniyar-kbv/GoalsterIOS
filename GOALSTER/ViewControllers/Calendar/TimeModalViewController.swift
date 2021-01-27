//
//  TimeModalViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/16/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class TimeModalViewController: CustomModalViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var timeModalView = TimeModalView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalView.setView(view: timeModalView)
        
        timeModalView.tableView.delegate = self
        timeModalView.tableView.dataSource = self
    }
    
    override func loadView() {
        super.loadView()
        
        view = modalView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeCell.reuseIdentifier, for: indexPath) as! TimeCell
        switch indexPath.row {
        case 0:
            cell.time = .morning
        case 1:
            cell.time = .day
        case 2:
            cell.time = .evening
        default:
            break
        }
        cell.isActive = cell.time == AppShared.sharedInstance.modalSelectedTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! TimeCell
            cell.isActive = i == indexPath.row
            if i == indexPath.row{
                let parentVc = parent as! AddGoalViewController
                parentVc.selectedTime = cell.time
                animateDown()
                AppShared.sharedInstance.modalSelectedTime = nil
            }
        }
    }
}

