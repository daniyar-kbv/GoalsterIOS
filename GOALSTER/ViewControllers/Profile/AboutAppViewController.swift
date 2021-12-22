//
//  AboutAppViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/15/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class AboutAppViewController: ProfileFirstViewController {
    lazy var mainView = AboutAppView()
    lazy var cellTypes: [AboutCell.CellType] = [.website, .instagram, .personalInstagram]
    
    override func loadView() {
        super.loadView()
        
        setView(mainView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("About app".localized)
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension AboutAppViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.reuseIdentifier, for: indexPath) as! AboutCell
        cell.type = cellTypes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(cellTypes[indexPath.row].url)
    }
}
