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
            mainView.tableView.reloadData()
            if users.count == 0 {
                viewModel.currentPage -= 1
            }
            mainView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: viewModel.currentPage == viewModel.totalPages ? StaticSize.size(15) : StaticSize.size(100), right: 0)
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
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseIdentifier, for: indexPath) as! FeedCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == tableView.numberOfRows(inSection: 0) else { return }
        viewModel.feed(type: type.rawValue)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userId = users[indexPath.row].id,
              let isCelebrity = users[indexPath.row].isCelebrity else { return }
        if ModuleUserDefaults.getIsLoggedIn() {
            if isCelebrity && !ModuleUserDefaults.getIsPremium() {
                present(PresentablePremiumViewController(), animated: true)
                return
            }
            navigationController?.pushViewController(FeedDetailViewController(userId: userId, superVc: self), animated: true)
        } else {
            present(FirstAuthViewController(), animated: true)
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
