//
//  TrackerManager.swift
//  GOALSTER
//
//  Created by Dan on 3/20/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import AppTrackingTransparency
import FBSDKCoreKit

class TrackerManager {
    static func setAdvertiserTracking() {
        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    let isAllowed = [.authorized, .restricted].contains(status)
                    Settings.setAdvertiserTrackingEnabled(isAllowed)
                    Settings.isAutoLogAppEventsEnabled = isAllowed
                    Settings.isAdvertiserIDCollectionEnabled = isAllowed
                })
            }
        }
    }
    
    static func setAdvancedMatching() {
        if #available(iOS 14, *) {
            if [.authorized, .restricted].contains(ATTrackingManager.trackingAuthorizationStatus) && ModuleUserDefaults.getIsLoggedIn() {
                AppEvents.setUserData(ModuleUserDefaults.getEmail(), forType: .email)
                AppEvents.setUserData(AppShared.sharedInstance.profile?.name, forType: .firstName)
            }
        }
    }
}
