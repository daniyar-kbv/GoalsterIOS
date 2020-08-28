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

class VisualizationsMainViewcontroller: BaseViewController {
    lazy var mainView = VisualizationsMainView()
    lazy var viewModel = VisulizationsMainViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var state: VisualizationsState = .notAdded
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
            state == .added && full != spheres?.count ? addAddButton(action: #selector(addTapped)) : removeAddButton()
            mainView.setUp(state: state)
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
        
        setView(mainView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Visualization".localized)
        
        mainView.collection.delegate = self
        mainView.collection.dataSource = self
        
        mainView.button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        viewModel.view = mainView
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch state {
        case .notAdded:
            mainView.animationView.play()
        default:
            break
        }
        
        reload()
        
    }
    
    @objc func onWillEnterForegroundNotification(){
        switch state {
        case .notAdded:
            mainView.animationView.play()
        default:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in mainView.collection.subviews {
            if view.accessibilityIdentifier == "shadowView" {
                view.removeFromSuperview()
            }
        }
        for i in 0..<mainView.collection.numberOfItems(inSection: 0) {
            if let cell = mainView.collection.cellForItem(at: IndexPath(item: i, section: 0)) as? VisualizationCell{
                var firstCell: VisualizationSmallCell?
                for j in 0..<cell.collection.numberOfItems(inSection: 0) {
                    if let cell_ = cell.collection.cellForItem(at: IndexPath(item: j, section: 0)) as? VisualizationSmallCell {
                        if j == 0 {
                            firstCell = cell_
                        }
                    }
                }
                if let firstCell = firstCell{
                    let view: UIView = {
                        let view = UIView()
                        view.layer.shadowColor = UIColor.gray.cgColor
                        view.layer.shadowRadius = StaticSize.size(5)
                        view.layer.shadowOpacity = 0.15
                        view.clipsToBounds = false
                        view.accessibilityIdentifier = "shadowView"
                        return view
                    }()
                    let innerView: UIView = {
                        let view = UIView()
                        view.layer.cornerRadius = StaticSize.size(17)
                        view.backgroundColor = .white
                        return view
                    }()
                    view.addSubview(innerView)
                    innerView.snp.makeConstraints({
                        $0.edges.equalToSuperview()
                    })
                    mainView.collection.addSubview(view)
                    view.snp.makeConstraints({
                        $0.top.bottom.equalTo(cell)
                        $0.left.equalTo(firstCell).offset(-StaticSize.size(11))
                        $0.width.equalTo(StaticSize.size(494))
                    })
                    mainView.collection.sendSubviewToBack(view)
                }
            }
        }
    }
    
    func reload() {
        if ModuleUserDefaults.getIsLoggedIn() {
            viewModel.getVisualizations()
        } else {
            state = .notAdded
            addAddButton(action: #selector(addTapped))
            mainView.setUp(state: state)
        }
    }
    
    func bind() {
        viewModel.spheres.subscribe(onNext: { spheres in
            DispatchQueue.main.async {
                self.spheres = spheres
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func addTapped() {
        if !ModuleUserDefaults.getIsLoggedIn() {
            present(AuthViewController(), animated: true, completion: nil)
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
        return cell
    }
}

extension VisualizationsMainViewcontroller: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: StaticSize.size(230))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: StaticSize.size(45), left: 0, bottom: StaticSize.size(45), right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return StaticSize.size(15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return StaticSize.size(15)
    }
}
