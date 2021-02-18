//
//  SearchObserverViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SearchObserverViewController: ChildViewController {
    lazy var searchView = SearchObserverView()
    lazy var viewModel = SearchObserverViewModel()
    lazy var disposeBag = DisposeBag()
    var users: [User]? {
        didSet {
            selectedUser = nil
            searchView.tableView.reloadData()
        }
    }
    var selectedUser: User? {
        didSet {
            searchView.addButton.isActive = selectedUser != nil
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        
        searchView.searchField.addTarget(self, action: #selector(onFieldChange(_:)), for: .editingChanged)
        searchView.closeButton.addTarget(self, action: #selector(clearField), for: .touchUpInside)
        searchView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        hideKeyboardWhenTappedAround()
    }
    
    @objc func addButtonTapped() {
        guard let parentVc = parentVc as? AddGoalViewController else { return }
        parentVc.selectedObserver = selectedUser
        backToParent()
    }
    
    func bind() {
        viewModel.users.subscribe(onNext: { users in
            DispatchQueue.main.async {
                self.users = users
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func onFieldChange(_ textField: UITextField) {
        viewModel.searchObserver(q: textField.text ?? "")
    }
    
    @objc func clearField() {
        users = []
        selectedUser = nil
        searchView.searchField.text = ""
    }
}

extension SearchObserverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchObserverCell.reuseIdentifier, for: indexPath) as! SearchObserverCell
        if indexPath.row == 0{
            cell.topLine.isHidden = false
        }
        cell.user = users?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = users?[indexPath.row]
    }
}
