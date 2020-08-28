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
        
        hideKeyboardWhenTappedAround()
        
        spheresView.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        if fromProfile {
            for sphere in ModuleUserDefaults.getSpheres() ?? [] {
                selected.append((key: Sphere.findByName(name: sphere.sphere ?? ""), value: sphere.sphere ?? ""))
            }
            spheresView.tableView.reloadData()
            spheresView.nextButton.isActive = selected.count == 3
            spheresView.nextButton.setTitle("Save changes".localized, for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableKeyboardDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if fromProfile && alertsCount == 0 {
            showAlert(title: "Shere changes alert text".localized,
                      yesCompletion: { _ in
            }, noCompletion: { _ in
                self.dismiss(animated: true, completion: nil)
            })
            alertsCount += 1
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
    
    @objc override func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            AppShared.sharedInstance.openedKeyboardSize = keyboardSize
            AppShared.sharedInstance.openedKeyboardSizeSubject.onNext(keyboardSize)
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification){
    }
}

extension SpheresListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spheres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpheresListCell.reuseIdentifier, for: indexPath) as! SpheresListCell
        cell.sphere = spheres[indexPath.row]
        cell.isActive = selected.contains(where: { $0.value == cell.sphere?.rawValue || $0.value == cell.sphere?.rawValue.localized }) || (cell.sphere == .addOwnOption && selected.contains(where: { $0.value == ownOption }) && !ownOption.isEmpty)
        if spheres[indexPath.row] == .addOwnOption {
            if !ownOption.isEmpty {
                cell.nameField.text = ownOption
            }
            cell.onChange = { text in
                self.ownOption = text ?? ""
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! SpheresListCell).isActive = (cell as! SpheresListCell).isActive ? true : false
    }
}
