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
    var currentIndex = 0
    
    override func loadView() {
        super.loadView()
        
        view = boardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardingView.collectionView.delegate = self
        boardingView.collectionView.dataSource = self
        
        configActions()
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
                boardingView.nextButton.setTitle("Ok".localized, for: .normal)
            }
            boardingView.indicatorView.setCurrent(index: currentIndex)
            boardingView.collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .right, animated: true)
        } else {
            let vc = AppShared.sharedInstance.tabBarController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCell.reuseIdentifier, for: indexPath) as! OnBoardingCell
            switch indexPath.row {
            case 0:
                cell.imageView.image = UIImage(named: "onBoarding1")
                cell.topText.text = "On boarding top text 1".localized
                cell.bottomText.text = "On boarding bottom text 1".localized
            case 1:
                cell.imageView.image = UIImage(named: "onBoarding2")
                cell.topText.text = "On boarding top text 2".localized
                cell.bottomText.text = "On boarding bottom text 2".localized
            case 2:
                cell.imageView.image = UIImage(named: "onBoarding3")
                cell.topText.text = "On boarding top text 3".localized
                cell.bottomText.text = "On boarding bottom text 3".localized
            case 3:
                cell.imageView.image = UIImage(named: "onBoarding4")
                cell.topText.text = "On boarding top text 4".localized
                cell.bottomText.text = "On boarding bottom text 4".localized
            default:
                break
            }
            return cell
        } else if indexPath.row == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingPremiumCell.reuseIdentifier, for: indexPath) as! OnBoardingPremiumCell
            return cell
        }
        return UICollectionViewCell(frame: CGRect())
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
        boardingView.nextButton.setTitle(currentIndex == 4 ? "Ok".localized : "Next".localized, for: .normal)
        boardingView.indicatorView.setCurrent(index: currentIndex)
    }
}
