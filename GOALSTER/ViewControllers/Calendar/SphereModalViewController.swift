//
//  SphereModalViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class SphereModalViewController: ChildViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var sphereModalView = SphereModalView()
    lazy var spheresToShow: [Int] = [0, 1, 2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sphereModalView.tableView.delegate = self
        sphereModalView.tableView.dataSource = self
        sphereModalView.backButton.onBack = backToParent
    }
    
    override func loadView() {
        super.loadView()
        
        view = sphereModalView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spheresToShow.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SphereCell.reuseIdentifier, for: indexPath) as! SphereCell
        cell.index = spheresToShow[indexPath.row]
        cell.sphere = ModuleUserDefaults.getSpheres()?[spheresToShow[indexPath.row]]
        cell.isActive = cell.sphere?.sphere == AppShared.sharedInstance.modalSelectedSphere?.0.sphere
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! SphereCell
            cell.isActive = i == indexPath.row
            if i == indexPath.row{
                if let parentVc = parentVc as? AddGoalViewController{
                    parentVc.selectedSphere = (cell.sphere!, cell.index!)
                } else if let parentVc = parentVc as? AddVisualizationViewController {
                    parentVc.selectedSphere = (cell.sphere!, cell.index!)
                }
                backToParent()
                AppShared.sharedInstance.modalSelectedSphere = nil
            }
        }
    }
}


