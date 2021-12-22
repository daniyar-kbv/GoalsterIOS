//
//  FeedDetailViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/17/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class FeedDetailViewController: UIViewController {
    lazy var mainView = FeedDetailView()
    lazy var viewModel = FeedDetailViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var tableVc: GoalsTableViewController = {
        let view = GoalsTableViewController()
        view.type = .feed
        view.user = user
        view.dayView = mainView.tableView
        view.date = Date()
        add(view)
        return view
    }()
    
    var superVc: FeedViewController
    var userId: Int
    var user: FeedUserFull? {
        didSet {
            mainView.user = user
            mainView.titleLabel.text = user?.profile?.name
        }
    }
    
    required init(userId: Int, superVc: FeedViewController) {
        self.userId = userId
        self.superVc = superVc
        
        super.init(nibName: .none, bundle: .none)
    }
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.spheresCollection.delegate = self
        mainView.spheresCollection.dataSource = self
        
        AppShared.sharedInstance.navigationController.delegate = self
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.delegate = self
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = true
        
        bind()
        
        viewModel.getUser(userId: userId)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableVc.user = user
        tableVc.response = user?.goals
    }
    
    func bind() {
        viewModel.user.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.user = object
            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user?.selected?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedSphereCell.reuseIdentifier, for: indexPath) as! FeedSphereCell
        cell.index = indexPath.item
        cell.type = .detail
        cell.sphere = user?.selected?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(collectionView.numberOfItems(inSection: 0)), height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension FeedDetailViewController: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is NavigationMenuBaseController {
            AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = false
            AppShared.sharedInstance.navigationController.delegate = nil
        }
    }
}
