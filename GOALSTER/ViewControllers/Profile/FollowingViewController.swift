//
//  FollowingViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/17/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class FollowingViewController: ProfileFirstViewController {
    lazy var mainView = FollowingView()
    lazy var viewModel = FollowingViewModel()
    lazy var disposeBag = DisposeBag()
    var users: [FeedUserFull] = [] {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        setView(mainView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Following".localized)
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        viewModel.view = mainView
        viewModel.getFollowing()
        
        bind()
    }
    
    func onUnfollow(_ user: FeedUserFull?) {
        var users = self.users
        users.removeAll(where: { $0.id == user?.id})
        self.users = users
        AppShared.sharedInstance.followedUser = user
    }
    
    func bind() {
        viewModel.users.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.users = object
            }
        }).disposed(by: disposeBag)
    }
}

extension FollowingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowingCell.reuseIdentifier, for: indexPath) as! FollowingCell
        cell.index = indexPath.row
        cell.user = users[indexPath.row]
        cell.followButton.onTap = onUnfollow(_:)
        return cell
    }
    
    
}
