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
    var observationId: Int?
    
    var observed: [Observed]? {
        didSet {
            profileView.tableView.reloadData()
            if let id = observationId {
                onSelect(id)
                observationId = nil
            }
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
        
        AppShared.sharedInstance.navigationController.delegate = self
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.delegate = self
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func bind() {
        viewModel.observed.subscribe(onNext: { observed in
            DispatchQueue.main.async {
                self.observed = observed
            }
        }).disposed(by: disposeBag)
    }
    
    func reload() {
        viewModel.getObserved()
    }
    
    func acceptObservation(_ button: UIButton, _ id: Int) {
        viewModel.acceptObservation(id: id, isConfirmed: button.accessibilityIdentifier == "acceptButton")
        if button.accessibilityIdentifier == "acceptButton" {
            observationId = id
        }
    }
    
    func onSelect(_ id: Int?) {
        if let id = id, observed?.first(where: { $0.id == id })?.isConfirmed ?? false {
            let vc = ObservedCalendarViewController(observation: id)
            navigationController?.pushViewController(vc, animated: true)
        }
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
        cell.onSelect = onSelect(_:)
        return cell
    }
}

extension ObservedViewController: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is NavigationMenuBaseController {
            AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = false
            AppShared.sharedInstance.navigationController.delegate = nil
        }
    }
}
