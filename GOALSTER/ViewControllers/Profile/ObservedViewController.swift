//
//  ObservedViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class ObservedViewController: ProfileBaseViewController {
    lazy var profileView = ObservedView()
    lazy var viewModel = ObservedViewModel()
    lazy var disposeBag = DisposeBag()
    
    var observed: [Observed]? {
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
        
        setTitle("Observe".localized)
        
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        
        bind()
        reload()
    }
    
    func bind() {
        viewModel.observed.subscribe(onNext: { observed in
            DispatchQueue.main.async {
                self.observed = observed
            }
        }).disposed(by: disposeBag)
        viewModel.success.subscribe(onNext: { success in
            DispatchQueue.main.async {
                self.success = success
            }
        }).disposed(by: disposeBag)
    }
    
    func reload() {
        viewModel.getObserved()
    }
    
    func acceptObservation(_ button: UIButton, _ id: Int) {
        viewModel.acceptObservation(id: id, isConfirmed: button.accessibilityIdentifier == "acceptButton")
    }
}

extension ObservedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observed?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ObservedCell.reuseIdentifier, for: indexPath) as! ObservedCell
        if indexPath.row == 0 {
            cell.topLine.isHidden = false
        }
        cell.onAccept = acceptObservation(_:_:)
        cell.observed = observed?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = observed?[indexPath.row].id {
            let vc = ObservedCalendarViewController(observation: id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
