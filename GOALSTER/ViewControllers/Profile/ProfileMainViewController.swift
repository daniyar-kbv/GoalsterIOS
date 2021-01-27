//
//  ProfileMainViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ProfileMainViewController: BaseViewController {
    lazy var profileView = ProfileMainView()
    lazy var viewModel = ProfileMainViewModel()
    lazy var disposeBag = DisposeBag()
    var count: Int = 0 {
        didSet {
            profileView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        setView(profileView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Profile".localized)
        
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        
        viewModel.view = view
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
    }
    
    func bind() {
        viewModel.count.subscribe(onNext: { count in
            DispatchQueue.main.async {
                self.count = count
            }
        }).disposed(by: disposeBag)
    }
    
    func reload() {
        viewModel.connect()
    }
}

extension ProfileMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileMainCell.reuseIdentifier, for: indexPath) as! ProfileMainCell
        switch indexPath.row {
        case 0:
            cell.type = .observe
            cell.topLine.isHidden = false
            cell.circle.isHidden = count == 0
            cell.number.text = "+\(count)"
        case 1:
            cell.type = .observers
        case 2, 6:
            cell.type = .empty
        case 3:
            cell.type = .language
        case 4:
            cell.type = .spheres
        case 5:
            cell.type = .premium
        case 7:
            cell.type = .notifications
        case 8:
            cell.type = .help
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ProfileMainCell
        switch cell.type {
        case .observe:
            if !ModuleUserDefaults.getIsPremium() {
                DispatchQueue.main.async {
                    let vc = ProfilePremiumViewController()
                    vc.setOnSuccess(onSuccess: {
                        vc.dismiss(animated: true, completion: {
                            self.navigationController?.pushViewController(ObservedViewController(), animated: true)
                        })
                    })
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                navigationController?.pushViewController(ObservedViewController(), animated: true)
            }
        case .observers:
            if !ModuleUserDefaults.getIsPremium() {
                let vc = ProfilePremiumViewController()
                vc.setOnSuccess(onSuccess: {
                    vc.dismiss(animated: true, completion: {
                        self.navigationController?.pushViewController(ObserversViewController(), animated: true)
                    })
                })
                self.present(vc, animated: true, completion: nil)
            } else {
                navigationController?.pushViewController(ObserversViewController(), animated: true)
            }
        case .language:
            AppShared.sharedInstance.tabBarController.openLanguagesModal()
        case .spheres:
            if ModuleUserDefaults.getHasSpheres() {
                let vc = SpheresListViewController()
                vc.fromProfile = true
                present(vc, animated: true, completion: nil)
            } else {
                AppShared.sharedInstance.tabBarController.toTab(tab: 0)
            }
        case .premium:
            if ModuleUserDefaults.getIsPremium() {
                break
            } else {
                self.present(ProfilePremiumViewController(), animated: true, completion: nil)
            }
        case .notifications:
            navigationController?.pushViewController(NotificatonsViewController(), animated: true)
        case .help:
            present(HelpViewController(), animated: true, completion: nil)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
