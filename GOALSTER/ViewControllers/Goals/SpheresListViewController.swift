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
    var cells: [SpheresListCell] = [] {
        didSet {
            spheresView.tableView.reloadData()
        }
    }
    var selected: [(key: Sphere, value: String)] = []
    var ownOption: String = "" {
        didSet {
            if let ownOptionSphere = selected.first(where: { $0.key == .addOwnOption }), let index = selected.firstIndex(where: { $0.key == .addOwnOption }) {
                
                selected.replaceSubrange(
                    index..<index+1,
                    with: [(key: ownOptionSphere.key, value: ownOption)]
                )
            }
        }
    }
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
            spheresView.nextButton.isActive = selected.count == 3
            ownOption = (ModuleUserDefaults.getSpheres() ?? [])[2].sphere ?? ""
        }
        
        loadCells()
        activateOwnOption(!fromProfile)
    }
    
    func loadCells() {
        var cells: [SpheresListCell] = []
        for i in 0..<spheres.count {
            let cell = spheresView.tableView.dequeueReusableCell(withIdentifier: SpheresListCell.reuseIdentifier, for: IndexPath(row: i, section: 0)) as! SpheresListCell
            cell.sphere = spheres[i]
            cell.isActive = selected.contains(where: { $0.value == cell.sphere?.rawValue.en || $0.value == cell.sphere?.rawValue.ru }) || (cell.sphere == .addOwnOption && selected.contains(where: { $0.value == ownOption }) && !ownOption.isEmpty)
            if spheres[i] == .addOwnOption {
                cell.nameField.additionalLift = StaticSize.size(100)
                if !ownOption.isEmpty {
                    cell.nameField.text = ownOption
                }
                cell.onChange = { text in
                    self.ownOption = text ?? ""
                }
            }
            cells.append(cell)
        }
        self.cells = cells
    }
    
    func activateOwnOption(_ activate: Bool = true) {
        cells.first(where: { $0.sphere == .addOwnOption })?.nameField.isUserInteractionEnabled = activate
    }
    
    @objc func nextTapped() {
        spheresView.endEditing(true)
        let vc = SpheresDescriptionViewController(spheres: selected)
        vc.fromProfile = fromProfile
        openTop(vc: vc)
    }
}

extension SpheresListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !fromProfile {
            onSelect(tableView, didSelectRowAt: indexPath)
        } else if alertsCount == 0 {
            showAlert(
                title: "Shere changes alert text".localized,
                yesCompletion: { _ in
                    self.onSelect(tableView, didSelectRowAt: indexPath)
                    self.fromProfile = false
                    self.activateOwnOption()
                },
                noCompletion: { _ in
                    self.dismiss(animated: true, completion: nil)
                }
            )
            alertsCount += 1
        }
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
