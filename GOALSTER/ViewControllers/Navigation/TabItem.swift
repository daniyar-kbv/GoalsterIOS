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
    case calendar = "calendar"
    case knowledge = "knowledge"
    case profile = "profile"
    
    var viewController: UIViewController {
        switch self {
        case .feed:
            return SegmentedViewController(segments: [.following, .recommendations])
        case .goals:
            return GoalsMainViewController()
        case .calendar:
            return DayViewController()
        case .knowledge:
            return KnowledgeViewController()
        case .profile:
            return ProfileMainViewController()
        }
    }
    
    var icon: UIImage {
        return UIImage(named: self.rawValue)!
    }
}
