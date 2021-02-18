//
//  LanguagesModalViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class LanguagesModalViewController: ProfileFirstViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var languagesModalView = LanguagesModalView()
    lazy var viewModel = LanguagesViewModel()
    lazy var disposeBag = DisposeBag()
    var selectedLanguage: Language = ModuleUserDefaults.getLanguage() {
        didSet {
            navigationController?.popViewController(animated: true)
            if selectedLanguage != ModuleUserDefaults.getLanguage() {
                viewModel.changeLanugage(language: selectedLanguage)
            }
        }
    }
    
    var success: Bool? {
        didSet {
            ModuleUserDefaults.setLanguage(selectedLanguage)
            if let vc = UIApplication.topViewController() as? ProfileMainViewController {
                vc.viewDidLoad()
                vc.profileView.tableView.reloadData()
                AppShared.sharedInstance.tabBarController.reloadOnLanguageChange()
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        setView(languagesModalView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("App's language".localized)
        
        languagesModalView.tableView.delegate = self
        languagesModalView.tableView.dataSource = self
        
        bind()
    }
    
    func bind() {
        viewModel.success.subscribe(onNext: { success in
            DispatchQueue.main.async {
                self.success = success
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func buttonTapped() {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.reuseIdentifier, for: indexPath) as! LanguageCell
        switch indexPath.row {
        case 0:
            cell.language = .ru
        case 1:
            cell.language = .en
        default:
            break
        }
        if ModuleUserDefaults.getLanguage() == cell.language {
            cell.isActive = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! LanguageCell
            cell.isActive = i == indexPath.row
            if i == indexPath.row, let language = cell.language{
                selectedLanguage = language
            }
        }
    }
}

