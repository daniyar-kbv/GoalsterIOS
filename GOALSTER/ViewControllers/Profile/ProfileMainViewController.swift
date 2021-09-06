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
import StoreKit

class ProfileMainViewController: UIViewController {
    lazy var profileView = ProfileMainView(vc: self)
    lazy var viewModel = ProfileMainViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var cellTypes: [ProfileCellType] = AppStoreReviewManager.isAppropriate() ? ProfileCellType.allCases : Array(ProfileCellType.allCases[0..<ProfileCellType.allCases.count-1])
    var count: Int = 0 {
        didSet {
            let cell = profileView.tableView.cellForRow(at: IndexPath(row: cellTypes.firstIndex(of: .observe) ?? 0, section: 0)) as? ProfileMainCell
            cell?.circle.isHidden = count == 0
            cell?.number.text = "\(count)"
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        profileView.mainScrollView.delegate = self
        
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
        AppShared.sharedInstance.profileSubject.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.profileView.avatarView.kf.setImage(with: URL(string: object?.avatar ?? ""))
                self.profileView.nameLabel.text = object?.name
            }
        }).disposed(by: disposeBag)
    }
    
    func reload() {
        viewModel.connect()
    }
}

extension ProfileMainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let diff = StaticSize.size(112) - scrollView.contentOffset.y
        let val = diff >= 0 ? diff : 0
        profileView.titleLabel.alpha = val / 112
    }
}

extension ProfileMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileMainCell.reuseIdentifier, for: indexPath) as! ProfileMainCell
        cell.type = cellTypes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ProfileMainCell
        switch cell.type {
        case .personalInfo:
            navigationController?.pushViewController(UpdateProfileViewController(), animated: true)
        case .observe:
            if !ModuleUserDefaults.getIsPremium() {
                DispatchQueue.main.async {
                    let vc = ProfilePremiumViewController()
                    vc.setOnSuccess(onSuccess: {
                        self.navigationController?.popViewController(animated: true)
                        AppShared.sharedInstance.navigationController?.pushViewController(ObservedViewController(), animated: true)
                    })
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                navigationController?.pushViewController(ObservedViewController(), animated: true)
            }
        case .observers:
            if !ModuleUserDefaults.getIsPremium() {
                let vc = ProfilePremiumViewController()
                vc.setOnSuccess(onSuccess: {
                    self.navigationController?.popViewController(animated: true)
                    AppShared.sharedInstance.navigationController?.pushViewController(ObserversViewController(), animated: true)
                })
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                navigationController?.pushViewController(ObserversViewController(), animated: true)
            }
        case .following:
            navigationController?.pushViewController(FollowingViewController(), animated: true)
        case .language:
            navigationController?.pushViewController(LanguagesModalViewController(), animated: true)
        case .premium:
            if ModuleUserDefaults.getIsPremium() {
                break
            } else {
                let vc = ProfilePremiumViewController()
                vc.setOnSuccess(onSuccess: {
                    self.reload()
                })
                navigationController?.pushViewController(ProfilePremiumViewController(), animated: true)
            }
        case .notifications:
            navigationController?.pushViewController(NotificatonsViewController(), animated: true)
        case .help:
            navigationController?.pushViewController(HelpViewController(), animated: true)
        case .about:
            navigationController?.pushViewController(AboutAppViewController(), animated: true)
        case .rateApp:
            AppStoreReviewManager.requestReviewIfAppropriate()
            if !AppStoreReviewManager.isAppropriate() {
                cellTypes = Array(ProfileCellType.allCases[0..<ProfileCellType.allCases.count-1])
                tableView.reloadData()
            }
        default:
            break
        }
    }
}
