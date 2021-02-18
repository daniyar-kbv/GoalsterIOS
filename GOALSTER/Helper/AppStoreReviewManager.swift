//
//  AppStoreReviewManager.swift
//  GOALSTER
//
//  Created by Dan on 2/18/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import StoreKit

class AppStoreReviewManager {
    static let minimumReviewWorthyActionCount = 3
    
    private static func getObjects() -> (UserDefaults, Int, String?, String?) {
        let defaults = UserDefaults.standard
        let bundle = Bundle.main
        
        var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)
        actionCount += 1
        
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)
        
        return (defaults, actionCount, currentVersion, lastVersion)
    }
    
    static func isAppropriate() -> Bool {
        let (_, actionCount, currentVersion, lastVersion) = getObjects()
        return (actionCount <= minimumReviewWorthyActionCount) && (lastVersion == nil || lastVersion != currentVersion)
    }

    static func requestReviewIfAppropriate() {
        guard isAppropriate() else { return }
        let (defaults, actionCount, currentVersion, _) = getObjects()
        
        SKStoreReviewController.requestReview()
    
        defaults.set(actionCount, forKey: .reviewWorthyActionCount)
        defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
    }
}
