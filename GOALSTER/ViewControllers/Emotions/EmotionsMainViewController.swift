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

class EmotionsMainViewController: BaseViewController {
    lazy var emotionsView = EmotionsMainView()
    lazy var state: EmotionsState = .notAdded
    lazy var viewModel = EmotionsMainViewModel()
    lazy var disposeBag = DisposeBag()
    var currentPage: Int?
    var emotions: [EmotionAnswer]? {
        didSet {
            state = emotions?.count ?? 0 > 0 ? .added : .notAdded
            emotionsView.progress.number = emotions?.count ?? 0
            emotionsView.finishSetUp(state: state)
            emotionsView.collection.reloadData()
            currentPage = 1
            emotionsView.progress.setProgress(number: currentPage ?? 1)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        setView(emotionsView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Emotions of the day".localized)
        
        viewModel.view = emotionsView
        
        emotionsView.collection.dataSource = self
        emotionsView.collection.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        emotionsView.button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch state {
        case .notAdded:
            emotionsView.animationView.play()
        default:
            break
        }
        
        onAppear()
    }
    
    @objc func onWillEnterForegroundNotification(){
        switch state {
        case .notAdded:
            emotionsView.animationView.play()
        default:
            break
        }
    }
    
    func bind() {
        viewModel.emotions.subscribe(onNext: { emotions in
            DispatchQueue.main.async {
                self.emotions = emotions
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func addTapped() {
        if !ModuleUserDefaults.getIsLoggedIn() {
            present(AuthViewController(), animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                let vc = AddEmotionsViewController()
                vc.superVc = self
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func onAppear() {
        if ModuleUserDefaults.getIsLoggedIn(){
            viewModel.getEmotions()
        } else {
            emotionsView.finishSetUp(state: state)
        }
    }
}

extension EmotionsMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionCell.reuseIdentifier, for: indexPath) as! EmotionCell
        cell.text.text = emotions?[indexPath.row].answer
        cell.question.text = emotions?[indexPath.row].question
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = emotionsView.collection.frame.size.width
        let currentPage = (emotionsView.collection.contentOffset.x / pageWidth) + 1
        self.currentPage = Int(currentPage)
        emotionsView.progress.setProgress(number: Int(currentPage))
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
