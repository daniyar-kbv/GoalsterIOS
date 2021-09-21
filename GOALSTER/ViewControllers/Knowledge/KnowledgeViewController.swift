//
//  KnowledgeViewController.swift
//  GOALSTER
//
//  Created by Dan on 9/20/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class KnowledgeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = KnowledgeView()
    private let viewModel = KnowledgeViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        viewModel.getSections(showLoaderOn: contentView)
        
        contentView.delegate = self
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.addGradientBackground()
    }
    
    private func bind() {
        viewModel.reload
            .subscribe(onNext: { [weak self] in
                self?.contentView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.openStories
            .subscribe(onNext: { [weak self] id, name in
                let storyVC = StoryController(id: id, name: name)
                self?.navigationController?.pushViewController(storyVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension KnowledgeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: KnowledgeCell.self), for: indexPath) as! KnowledgeCell
        let cellInfo = viewModel.getCellInfo(for: indexPath.item)
        cell.set(title: cellInfo.title,
                 imageURL: cellInfo.imageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - StaticSize.size(48)) / 2
        let height = width * (147 / 164)
        return .init(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return StaticSize.size(16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.item)
    }
}

extension KnowledgeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let diff = Global.safeAreaTop() - scrollView.contentOffset.y
        let val = diff >= 0 ? diff : 0
        contentView.titleLabel.alpha = val / Global.safeAreaTop()
    }
}

extension KnowledgeViewController: KnowledgeViewDelegate {
    func refresh() {
        viewModel.getSections(showLoaderOn: contentView)
    }
}
