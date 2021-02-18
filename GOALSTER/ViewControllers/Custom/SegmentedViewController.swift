//
//  SegmentedViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/8/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class SegmentedViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, SegmentControllDelegate {
    lazy var mainView = SegmentedView(segments: segments)
    lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    var segments: [SegmentType]
    lazy var viewControllers: [SegmentVc] = segments.map({ $0.viewController })
    lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    required init(segments: [SegmentType]) {
        self.segments = segments
        
        super.init(nibName: .none, bundle: .none)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.segmentControll.delegate = self
        pageViewController.setViewControllers([viewControllers.first!], direction: .forward, animated: true, completion: nil)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        add(pageViewController, onView: mainView.contentView)
        pageViewController.view.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    func segmentTapped(_ segment: SegmentType) {
        guard let currentIndex = segments.firstIndex(of: mainView.segmentControll.currentSegment),
              let nextIndex = segments.firstIndex(of: segment)
        else { return }
        pageViewController.setViewControllers([viewControllers[nextIndex]], direction: nextIndex < currentIndex ? .reverse : .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? SegmentVc, let segment = SegmentType.allCases.first(where: { viewController.identifier == $0.viewController.identifier }), let index = segments.firstIndex(of: segment) else { return nil }
        if index > 0 {
            let nextSegment = segments[index - 1]
            return nextSegment.viewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? SegmentVc, let segment = SegmentType.allCases.first(where: { viewController.identifier == $0.viewController.identifier }), let index = segments.firstIndex(of: segment) else { return nil }
        if index < segments.count - 1 {
            let nextSegment = segments[index + 1]
            return nextSegment.viewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let pendingViewControllers = pendingViewControllers as? [SegmentVc], let segment = segments.first(where: { $0.viewController.identifier == pendingViewControllers.first?.identifier}) else { return }
        mainView.segmentControll.setCurrentSegment(segment: segment)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished && !completed {
            guard let previousViewControllers = previousViewControllers as? [SegmentVc], let segment = segments.first(where: { $0.viewController.identifier == previousViewControllers.last?.identifier}) else { return }
            mainView.segmentControll.setCurrentSegment(segment: segment)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SegmentVc: UIViewController {
    var identifier: String
    
    required init(id: String) {
        self.identifier = id
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
