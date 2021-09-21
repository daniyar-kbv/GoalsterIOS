//
//  KnowledgeViewModel.swift
//  GOALSTER
//
//  Created by Dan on 9/20/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class KnowledgeViewModel {
    let reload = PublishRelay<Void>()
    let openStories = PublishRelay<(Int, String)>()
    
    private var sections = [KnowledgeSection]() {
        didSet {
            reload.accept(())
        }
    }
    
    func getSections(showLoaderOn view: UIView) {
        view.showSpinnerViewCenter()
        APIManager.shared.getKnowledgeSections { [weak self] error, sections in
            SpinnerView.removeSpinnerView()
            guard let sections = sections else { return }
            self?.sections = sections
        }
    }
    
    func getNumberOfItems() -> Int {
        return sections.count
    }
    
    func getCellInfo(for index: Int) -> (title: String, imageURL: URL?) {
        let section = sections[index]
        return (section.name, section.image)
    }
    
    func didSelectRow(at index: Int) {
        let section = sections[index]
        openStories.accept((section.id, section.name))
    }
}
