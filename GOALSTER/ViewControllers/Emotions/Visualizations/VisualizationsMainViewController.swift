//
//  VisualizationsMainViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/19/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class VisualizationsMainViewcontroller: SegmentVc {
    lazy var mainView = VisualizationsMainView()
    lazy var viewModel = VisulizationsMainViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var didAppear = false
    lazy var state: VisualizationsState = .notAdded {
        didSet {
            if state != mainView.state {
                mainView.state = state
                mainView.setUp(state: state)
            }
        }
    }
    var spheres: [SphereVisualization]? {
        didSet {
            var cnt = 0
            var toDisplay: [(Int, SphereVisualization)] = []
            var full = 0
            for (index, visualizations) in (spheres ?? []).enumerated(){
                if visualizations.visualizations?.count ?? 0 > 0 {
                    cnt += 1
                    toDisplay.append((index, visualizations))
                    if visualizations.visualizations?.count ?? 0 == 3 {
                        full += 1
                    }
                }
            }
            state = cnt > 0 ? .added : .notAdded
            mainView.showAddButton = state == .added && full != spheres?.count
            mainView.collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: state == .added && full != spheres?.count ? StaticSize.tabBarHeight + StaticSize.buttonHeight + StaticSize.size(30) : StaticSize.tabBarHeight, right: 0)
            spheresToDisplay = toDisplay
        }
    }
    var spheresToDisplay: [(Int, SphereVisualization)]? {
        didSet {
            mainView.collection.reloadData()
            mainView.layoutIfNeeded()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collection.delegate = self
        mainView.collection.dataSource = self
        
        mainView.button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        viewModel.view = view
        bind()
        
        if ModuleUserDefaults.getIsLoggedIn() {
            if let visualizations = AppShared.sharedInstance.visualizations {
                spheres = visualizations
            }
            viewModel.getVisualizations(withSpinner: false)
        } else {
            state = .notAdded
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ModuleUserDefaults.getIsLoggedIn() {
            if didAppear {
                viewModel.getVisualizations(withSpinner: false)
            } else {
                didAppear = true
            }
        }
    }
    
    func onDelete(_ id: Int?) {
        let updatedSpheres = spheres
        if let index = updatedSpheres?.firstIndex(where: {
            $0.visualizations?.contains(where: { visualization in
                visualization.id == id
            }) ?? false
        }) {
            updatedSpheres?[index].visualizations?.removeAll(where: { $0.id == id })
        }
        spheres = updatedSpheres
        viewModel.deleteVisualization(id: id, withSpinner: false)
    }
    
    func bind() {
        viewModel.spheres.subscribe(onNext: { spheres in
            DispatchQueue.main.async {
                self.spheres = spheres
            }
        }).disposed(by: disposeBag)
        AppShared.sharedInstance.isLoggedInSubject.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.viewWillAppear(true)
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func addTapped() {
        if !ModuleUserDefaults.getIsLoggedIn() {
            present(FirstAuthViewController(), animated: true, completion: nil)
        } else if !ModuleUserDefaults.getHasSpheres() {
            AppShared.sharedInstance.tabBarController.toTab(tab: 1)
        } else {
            let vc = AddVisualizationViewController()
            vc.spheres = spheres
            vc.superVc = self
            present(vc, animated: true, completion: nil)
        }
    }
    
    func smallCellTapped(_ visualizations: [Visualization]?, _ index: Int) {
        let vc = ImageSliderViewController()
        vc.visualizations = visualizations
        vc.currentPage = index
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension VisualizationsMainViewcontroller: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spheresToDisplay?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisualizationCell.reuseIdentifier, for: indexPath) as! VisualizationCell
        cell.index = spheresToDisplay?[indexPath.row].0
        cell.sphere = spheresToDisplay?[indexPath.row].1
        cell.onTap = smallCellTapped(_:_:)
        cell.onDelete = onDelete(_:)
        return cell
    }
}

extension VisualizationsMainViewcontroller: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: StaticSize.size(230))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: StaticSize.size(28), left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return StaticSize.size(15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return StaticSize.size(15)
    }
}
