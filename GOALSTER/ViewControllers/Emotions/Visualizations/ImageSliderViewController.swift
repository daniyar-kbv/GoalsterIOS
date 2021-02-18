//
//  ImageSliderViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ImageSliderViewController: UIViewController {
    lazy var imageView = ImageSliderView()
    var currentPage = 0 {
        didSet {
            if let count = visualizations?.count{
                imageView.setNumber(number: currentPage + 1, total: count)
            }
        }
    }
    
    var visualizations: [Visualization]? {
        didSet {
            imageView.collection.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        imageView.collection.delegate = self
        imageView.collection.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.layoutIfNeeded()
        imageView.collection.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func close() {
        navigationController?.popViewController(animated: false)
    }
}

extension ImageSliderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visualizations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
        if let url = URL(string: visualizations?[indexPath.row].image ?? "") {
            cell.image.kf.setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = imageView.collection.frame.size.width
        let currentPage = (imageView.collection.contentOffset.x / pageWidth)
        self.currentPage = Int(currentPage)
    }
}
