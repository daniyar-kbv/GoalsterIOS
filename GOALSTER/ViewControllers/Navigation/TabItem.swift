//
//  TabItem.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

enum TabItem: String, CaseIterable {
    case feed = "feed"
    case goals = "goals"
    case emotions = "emotions"
    case calendar = "calendar"
    case profile = "profile"
    
    var viewController: UIViewController {
        switch self {
        case .feed:
            return SegmentedViewController(segments: [.following, .recommendations])
        case .goals:
            return GoalsMainViewController()
        case .emotions:
            return SegmentedViewController(segments: [.emotions, .visualizations])
        case .calendar:
            return DayViewController()
        case .profile:
            return ProfileMainViewController()
        }
    }
    
    var icon: UIImage {
        return UIImage(named: self.rawValue)!
    }
}
