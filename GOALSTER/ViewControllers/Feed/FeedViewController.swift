//
//  FeedViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/5/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class FeedViewController: SegmentVc, UITableViewDelegate, UITableViewDataSource {
    lazy var mainView = FeedView(type: type)
    lazy var viewModel = FeedViewModel(vc: self)
    lazy var disposeBag = DisposeBag()
    lazy var refreshControl = UIRefreshControl()
    var type: VCType
    var users: [FeedUser] = [] {
        didSet {
            refreshControl.endRefreshing()
            if (users.count == 0) != mainView.isEmpty {
                mainView.isEmpty = users.count == 0
            }
            if users.count == 0 {
                viewModel.currentPage -= 1
            }
            mainView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: viewModel.currentPage == viewModel.totalPages ? StaticSize.size(15) : StaticSize.size(100), right: 0)
            
            cells.removeAll()
            users.enumerated().forEach({ index, user in
                cells.append(.user(user))
                if (index + 1) % 6 == 0 && !ModuleUserDefaults.getIsPremium() {
                    cells.append(.premiumButton)
                }
            })
        }
    }
    var cells = [FeedCellType]() {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
    required init(type: VCType, id: String) {
        self.type = type
        
        super.init(id: id)
    }
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.bottomButton.addTarget(self, action: #selector(toRecommendationsTapped), for: .touchUpInside)
        
        mainView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        if type == .following {
            AppShared.sharedInstance.followingVc = self
        }
        
        if ModuleUserDefaults.getIsLoggedIn() || type == .recommendations {
            viewModel.feed(type: type.rawValue)
        } else {
            mainView.isEmpty = true
        }
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if mainView.isEmpty ?? true && ModuleUserDefaults.getIsLoggedIn() {
            viewModel.feed(type: type.rawValue)
        }
    }
    
    func bind() {
        AppShared.sharedInstance.isLoggedInSubject.subscribe(onNext: { object in
            DispatchQueue.main.async {
                switch self.type {
                case .following:
                    self.viewWillAppear(true)
                case .recommendations:
                    self.onRefresh()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func onRefresh() {
        viewModel.users.removeAll()
        viewModel.currentPage = 0
        viewModel.feed(type: type.rawValue, withSpinner: false)
    }
    
    @objc func toRecommendationsTapped() {
        guard let segmentedVc = parent?.parent as? SegmentedViewController, let recommendationButton = segmentedVc.mainView.segmentControll.arrangedSubviews.first(where: { ($0 as? SegmentButton)?.segment == .recommendations }) as? SegmentButton else { return }
        segmentedVc.mainView.segmentControll.buttonTapped(recommendationButton)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case let .user(user):
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseIdentifier, for: indexPath) as! FeedCell
            cell.user = user
            return cell
        case .premiumButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedPremiumCell.reuseIdentifier, for: indexPath) as! FeedPremiumCell
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == tableView.numberOfRows(inSection: 0) else { return }
        viewModel.feed(type: type.rawValue)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case let .user(user):
            guard let userId = user.id,
                  let isCelebrity = user.isCelebrity else { return }
            if ModuleUserDefaults.getIsLoggedIn() {
                if isCelebrity && !ModuleUserDefaults.getIsPremium() {
                    present(PresentablePremiumViewController(), animated: true)
                    return
                }
                navigationController?.pushViewController(FeedDetailViewController(userId: userId, superVc: self), animated: true)
            } else {
                present(FirstAuthViewController(), animated: true)
            }
        case .premiumButton:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(id: String) {
        fatalError("init(id:) has not been implemented")
    }
    
    enum VCType: String {
        case following
        case recommendations
    }
}

extension FeedViewController: FeedPremiumCellDelegate {
    func buttonTapped() {
        present(PresentablePremiumViewController(), animated: true)
    }
}

enum FeedCellType {
    case premiumButton
    case user(FeedUser)
}
