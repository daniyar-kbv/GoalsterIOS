//
//  StoriesController.swift
//  GOALSTER
//
//  Created by Dan on 9/21/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class StoryController: ProfileFirstViewController {
    private let disposeBag = DisposeBag()
    private let contentView = StoryView()
    private let viewModel = StoryViewModel()
    
    private let id: Int
    private let name: String
    private var cells = [StoryCell]()
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        
        super.init(nibName: .none, bundle: .none)
        
        showGradient = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        setView(contentView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTitle()
        
        contentView.mainCollection.delegate = self
        contentView.mainCollection.dataSource = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(collectionTapped))
        contentView.mainCollection.addGestureRecognizer(gestureRecognizer)
        
        bind()
        viewModel.getStories(by: id)
    }
    
    private func configTitle() {
        setTitle(name)
        baseView.titleLabel.font = .primary(ofSize: StaticSize.size(17), weight: .semiBold)
        baseView.titleLabel.textColor = .deepBlue
    }
    
    private func bind() {
        viewModel.didGetStories
            .subscribe(onNext: { [weak self] storiesInfo in
                self?.reloadIndicators()
                self?.reloadCells(storiesInfo: storiesInfo)
            })
            .disposed(by: disposeBag)
    }
    
    private func reloadCells(storiesInfo: [(id: Int, imageURL: URL?, text: String)]) {
        cells = storiesInfo.enumerated().map { index, info in
            let cell = contentView.mainCollection.dequeueReusableCell(withReuseIdentifier: String(describing: StoryCell.self), for: IndexPath(item: index, section: 0)) as! StoryCell
            cell.delegate = self
            cell.set(id: info.id, imageURL: info.imageURL, text: info.text)
            return cell
        }
        contentView.mainCollection.reloadData()
    }
    
    private func reloadIndicators() {
        self.contentView.reloadIndicators(index: viewModel.currentIndex,
                                          number: viewModel.numberOfItems())
    }
    
    @objc func collectionTapped(sender: UITapGestureRecognizer) {
        let point = sender.location(in: contentView)
        
        let isIncrement = point.x > contentView.mainCollection.frame.width / 2
        viewModel.changeIndex(isIncrement: isIncrement)
        contentView.mainCollection.scrollToItem(at: .init(item: viewModel.currentIndex, section: 0),
                                                at: .centeredHorizontally,
                                                animated: false)
        reloadIndicators()
    }
}

extension StoryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cells[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

extension StoryController: StoryCellDelegate {
    func buttonTapped(id: Int) {
        viewModel.tapped(on: id)
    }
}
