//
//  EmotionsMainViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/18/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class EmotionsMainViewController: SegmentVc {
    lazy var emotionsView = EmotionsMainView()
    lazy var state: EmotionsState = .notAdded {
        didSet {
            emotionsView.finishSetUp(state: state)
        }
    }
    lazy var viewModel = EmotionsMainViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var initial = true
    lazy var didAppear = false
    var currentPage: Int?
    
    var emotions: [EmotionAnswer]? {
        didSet {
            state = emotions?.count ?? 0 > 0 ? .added : .notAdded
            emotionsView.progress.number = emotions?.count ?? 0
            emotionsView.collection.reloadData()
            if initial {
                currentPage = 1
            }
            emotionsView.progress.setProgress(number: currentPage, animated: false)
            initial = false
            AppShared.sharedInstance.emotions = emotions
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = emotionsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = view
        
        emotionsView.collection.dataSource = self
        emotionsView.collection.delegate = self
        
        emotionsView.button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        if ModuleUserDefaults.getIsLoggedIn(){
            if let emotions = AppShared.sharedInstance.emotions {
                self.emotions = emotions
            }
            viewModel.getEmotions(withSpinner: false)
        } else {
            state = .notAdded
        }
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if didAppear && ModuleUserDefaults.getIsLoggedIn() {
            viewModel.getEmotions(withSpinner: false)
        } else {
            didAppear = true
        }
    }
    
    func bind() {
        viewModel.emotions.subscribe(onNext: { emotions in
            DispatchQueue.main.async {
                self.emotions = emotions
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
        } else {
            DispatchQueue.main.async {
                let vc = AddEmotionsViewController()
                vc.superVc = self
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension EmotionsMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionCell.reuseIdentifier, for: indexPath) as! EmotionCell
        cell.text.text = emotions?[indexPath.row].answer?.localized
        cell.question.text = emotions?[indexPath.row].question?.localized
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = emotionsView.collection.frame.size.width
        let currentPage = (emotionsView.collection.contentOffset.x / pageWidth) + 1
        self.currentPage = Int(currentPage)
        emotionsView.progress.setProgress(number: Int(currentPage))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        emotionsView.progress.setProgress(number: indexPath.item + 1)
    }
}

extension EmotionsMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
