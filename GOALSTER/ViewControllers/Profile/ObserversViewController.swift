//
//  ObserversViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class ObserversViewController: ProfileBaseViewController, UIGestureRecognizerDelegate {
    lazy var profileView = ObserversView()
    lazy var viewModel = ObserversViewModel()
    lazy var disposeBag = DisposeBag()
    
    var observers: [Observer]? {
        didSet {
            profileView.tableView.reloadData()
        }
    }
    
    var success: Bool? {
        didSet {
            reload()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        setView(profileView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("My observers".localized)
        
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        
        bind()
        reload()
        
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.delegate = self
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func bind() {
        viewModel.observers.subscribe(onNext: { observers in
            DispatchQueue.main.async {
                self.observers = observers
            }
        }).disposed(by: disposeBag)
        viewModel.success.subscribe(onNext: { success in
            DispatchQueue.main.async {
                self.success = success
            }
        }).disposed(by: disposeBag)
    }
    
    func reload() {
        viewModel.getObservers()
    }
    
    func deleteObservation(_ id: Int) {
        showAlert(title: "Do you really want to delete selected observer?".localized,
                  yesCompletion: { _ in
                      self.viewModel.deleteObservation(id: id)
                  },
                  noCompletion: { _ in
                      
                  })
        
    }
}

extension ObserversViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ObserverCell.reuseIdentifier, for: indexPath) as! ObserverCell
        if indexPath.row == 0 {
            cell.topLine.isHidden = false
        }
        cell.onTap = deleteObservation(_:)
        cell.observer = observers?[indexPath.row]
        return cell
    }
}

