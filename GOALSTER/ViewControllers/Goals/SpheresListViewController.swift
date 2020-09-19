//
//  SpheresListViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class SpheresListViewController: UIViewController {
    lazy var spheresView = SpheresListView()
    let spheres: [Sphere] = [.health, .education, .finances, .relationships, .career, .spirituality, .creation, .personalGrowth, .lifeBrightness, .family, .encirclement, .selfCultivation, .interests, .intellect, .sport, .leisure, .income, .recreation, .hobby, .travel, .addOwnOption]
    var selected: [(key: Sphere, value: String)] = []
    var ownOption: String = ""
    lazy var fromProfile = false
    var alertsCount = 0
    
    override func loadView() {
        super.loadView()
        
        view = spheresView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spheresView.tableView.delegate = self
        spheresView.tableView.dataSource = self
        
        spheresView.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        if fromProfile {
            for sphere in ModuleUserDefaults.getSpheres() ?? [] {
                selected.append((key: Sphere.findByName(name: sphere.sphere ?? ""), value: sphere.sphere?.localized ?? ""))
            }
            spheresView.tableView.reloadData()
            spheresView.nextButton.isActive = selected.count == 3
        }
    }
    
    @objc func nextTapped() {
        if fromProfile {
            
        }
        let vc = SpheresDescriptionViewController()
        vc.spheres = selected
        vc.fromProfile = fromProfile
        openTop(vc: vc)
    }
}

extension SpheresListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spheres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpheresListCell.reuseIdentifier, for: indexPath) as! SpheresListCell
        cell.sphere = spheres[indexPath.row]
        cell.isActive = selected.contains(where: { $0.value == cell.sphere?.rawValue.en || $0.value == cell.sphere?.rawValue.ru }) || (cell.sphere == .addOwnOption && selected.contains(where: { $0.value == ownOption }) && !ownOption.isEmpty)
        if spheres[indexPath.row] == .addOwnOption {
            if !ownOption.isEmpty {
                cell.nameField.text = ownOption
                cell.nameField.textColor = .customTextBlack
            } else {
                cell.nameField.textColor = .lightGray
            }
            cell.onChange = { text in
                self.ownOption = text ?? ""
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !fromProfile {
            onSelect(tableView, didSelectRowAt: indexPath)
        } else if alertsCount == 0 {
            showAlert(title: "Shere changes alert text".localized,
                      yesCompletion: { _ in
                        self.onSelect(tableView, didSelectRowAt: indexPath)
                        self.fromProfile = false
                      },
                      noCompletion: { _ in
                      })
            alertsCount += 1
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! SpheresListCell).isActive = (cell as! SpheresListCell).isActive ? true : false
    }
    
    func onSelect(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SpheresListCell
        if cell.isActive{
            cell.isActive = false
            if let index = selected.firstIndex(where: { $0.value == cell.nameField.text ?? ""}){
                selected.remove(at: index)
            }
        } else {
            if selected.count < 3 {
                if !(ownOption.isEmpty && cell.sphere == .addOwnOption){
                    cell.isActive = true
                    if let text = cell.nameField.text{
                        selected.append((key: cell.sphere!, value: text))
                    }
                }
            }
        }
        spheresView.nextButton.isActive = selected.count == 3
    }
}
