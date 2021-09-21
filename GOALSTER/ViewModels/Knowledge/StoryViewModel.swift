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
            reload.accept(())
        }
    }
    private(set) var currentIndex = 0
    
    let reload = PublishRelay<Void>()
    
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
    
    func getStoryInfo(for index: Int) -> (id: Int, imageURL: URL?, text: String) {
        let story = stories[index]
        return (story.id, story.image, story.text)
    }
    
    func changeIndex(isIncrement: Bool) {
        if isIncrement && currentIndex < stories.count - 1 {
            currentIndex += 1
        } else if !isIncrement && currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    func tapped(on storyId: Int) {
        print(storyId)
        guard let url = stories.first(where: { $0.id == storyId })?.link,
              UIApplication.shared.canOpenURL(url) else { return }
        print(url)
        UIApplication.shared.open(url, options: [:])
    }
}
