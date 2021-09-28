//
//  OnBoardingViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class OnBoardingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var products = [(identifier: String, price: String)]()
    
    lazy var boardingView = OnBoardingView()
    var currentIndex = 0
    
    var cells: [UICollectionViewCell]? {
        didSet {
            boardingView.collectionView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = boardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardingView.collectionView.delegate = self
        boardingView.collectionView.dataSource = self
        
        configActions()
        bind()
        
        SpinnerView.showSpinnerView()
        InAppPurchaseManager.shared.getProducts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addGradientBackground()
    }
    
    private func bind() {
        InAppPurchaseManager.shared
            .didGetProducts
            .subscribe(onNext: { [weak self] products in
                self?.process(products: products)
            })
            .disposed(by: disposeBag)
    }
    
    private func process(products: [(identifier: String, price: String)]) {
        SpinnerView.removeSpinnerView()
        self.products = products
        loadCells()
    }
    
    func configActions() {
        boardingView.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    @objc func nextTapped() {
        currentIndex += 1
        if currentIndex < 5{
            if currentIndex == 4 {
                boardingView.nextButton.setTitle("Ok_".localized, for: .normal)
            }
            boardingView.indicatorView.setCurrent(index: currentIndex)
            boardingView.collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .right, animated: true)
        } else {
            let vc = AppShared.sharedInstance.tabBarController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loadCells() {
        var cells_: [UICollectionViewCell] = []
        for i in 0..<5 {
            if i < 4 {
                let cell = boardingView.collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCell.reuseIdentifier, for: IndexPath(item: i, section: 0)) as! OnBoardingCell
                cell.type = OnBoardingCell.ViewType(rawValue: i)
                cells_.append(cell)
            } else if i == 4 {
                let cell = boardingView.collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingPremiumCell.reuseIdentifier, for: IndexPath(item: i, section: 0)) as! OnBoardingPremiumCell
                
                let plans = products.compactMap { product -> (type: PlanView.PlanType, price: String)? in
                    guard let type = PlanView.PlanType(rawValue: product.identifier) else { return nil }
                    return (type, product.price)
                }
                
                cell.setUp(plans: plans)
                cells_.append(cell)
            }
        }
        cells = cells_
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cells?[indexPath.row] ?? UICollectionViewCell(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: StaticSize.size(610))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = boardingView.collectionView.frame.size.width
        let currentPage = (boardingView.collectionView.contentOffset.x / pageWidth)
        currentIndex = Int(currentPage)
        boardingView.nextButton.setTitle(currentIndex == 4 ? "Ok_".localized : "Next".localized, for: .normal)
        boardingView.indicatorView.setCurrent(index: currentIndex)
    }
}
