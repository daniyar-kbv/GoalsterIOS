//
//  StoryViewModel.swift
//  GOALSTER
//
//  Created by Dan on 9/21/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class StoryViewModel {
    private var stories = [KnowledgeStory]() {
        didSet {
            didGetStories.accept(stories.map({ story in
                (story.id, story.image, story.text)
            }))
        }
    }
    private(set) var currentIndex = 0
    
    let didGetStories = PublishRelay<[(id: Int, imageURL: URL?, text: String)]>()
    
    func getStories(by sectionId: Int) {
        SpinnerView.showSpinnerView()
        APIManager.shared.getStories(of: sectionId) { [weak self] error, stories in
            SpinnerView.removeSpinnerView()
            guard let stories = stories else { return }
            self?.stories = stories
        }
    }
    
    func numberOfItems() -> Int {
        return stories.count
    }
    
    func changeIndex(isIncrement: Bool) {
        if isIncrement && currentIndex < stories.count - 1 {
            currentIndex += 1
        } else if !isIncrement && currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    func tapped(on storyId: Int) {
        guard let url = stories.first(where: { $0.id == storyId })?.link,
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}
