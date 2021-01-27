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
    case goals = "goals"
    case emotions = "emotions"
    case calendar = "calendar"
    case visualizations = "visualizations"
    case profile = "profile"
    
    var viewController: UIViewController {
        switch self {
        case .goals:
            return GoalsMainViewController()
        case .emotions:
            return EmotionsMainViewController()
        case .calendar:
            return DayViewController()
        case .visualizations:
            return VisualizationsMainViewcontroller()
        case .profile:
            return ProfileMainViewController()
        }
    }
    
    var icon_active: UIImage {
        return UIImage(named: "\(self.rawValue)_active")!
    }
    
    var icon_inactive: UIImage {
        return UIImage(named: "\(self.rawValue)_inactive")!
    }
}
