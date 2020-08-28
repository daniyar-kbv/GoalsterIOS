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

class LanguagesModalViewController: CustomModalViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var languagesModalView = LanguagesModalView()
    lazy var viewModel = LanguagesViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var selectedLanguage: Language = ModuleUserDefaults.getLanguage()
    
    var success: Bool? {
        didSet {
            ModuleUserDefaults.setLanguage(selectedLanguage)
            let vc = NavigationMenuBaseController()
            AppShared.sharedInstance.tabBarController = vc
            self.navigationController?.pushViewController(vc, animated: false)
            vc.toTab(tab: 4)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalView.setView(view: languagesModalView)
        
        languagesModalView.tableView.delegate = self
        languagesModalView.tableView.dataSource = self
        
        languagesModalView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        bind()
    }
    
    override func loadView() {
        super.loadView()
        
        view = modalView
    }
    
    func bind() {
        viewModel.success.subscribe(onNext: { success in
            DispatchQueue.main.async {
                self.success = success
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func buttonTapped() {
        animateDown()
        if selectedLanguage != ModuleUserDefaults.getLanguage() {
            viewModel.changeLanugage(language: selectedLanguage)
        }
    }
    
    override func animateDown(onStart: (() -> ())? = nil) {
        super.animateDown(onStart: {
            self.languagesModalView.button.isHidden = true
        })
    }
    
    override func openContainer(completion: ((Bool) -> Void)? = nil) {
        super.openContainer(completion: { _ in
            self.languagesModalView.button.isHidden = false
        })
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

