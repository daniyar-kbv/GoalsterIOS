//
//  OnBoardingViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class OnBoardingViewController: UIViewController {
    lazy var boardingView = OnBoardingView()
    lazy var premiumVc = PayBallController()
    var currentIndex = 0
    var cells: [UICollectionViewCell]? {
        didSet {
            boardingView.collectionView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = boardingView
        
        premiumVc.hideTopBrush()
        premiumVc.hideBackButton()
        addChild(premiumVc)
        premiumVc.didMove(toParent: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardingView.collectionView.delegate = self
        boardingView.collectionView.dataSource = self
        
        configActions()
        
        loadCells()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addGradientBackground()
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
                cell.premiumView.addSubview(premiumVc.view)
                premiumVc.view.snp.makeConstraints({
                    $0.edges.equalToSuperview()
                })
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
