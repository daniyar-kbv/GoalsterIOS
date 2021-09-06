//
//  PushNotificationsManager.swift
//  GOALSTER
//
//  Created by Dan on 5/17/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class PushNotificationsManager {
    static let shared = PushNotificationsManager()
    
    private init() {
        getNotificationsAllowed() { self.isNotificationsAllowed = $0 }
    }
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var isNotificationsAllowed: Bool? = ModuleUserDefaults.getIsNotificationsEnabled() {
        didSet {
            switch isNotificationsAllowed {
            case false:
                notificationCenter.removeAllPendingNotificationRequests()
            case true:
                PushType.enableAll()
            default:
                getNotificationsAllowed() { self.isNotificationsAllowed = $0 }
            }
            guard let enabled = isNotificationsAllowed else { return }
            ModuleUserDefaults.setIsNotificationsEnabled(enabled)
        }
    }
    
    func getNotificationsAllowed(_ completion: @escaping (Bool?)->()){
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                guard ModuleUserDefaults.getIsLoggedIn() else {
                    completion(false)
                    return
                }
                APIManager.shared.getNotifications() { error, response in
                    completion(response?.enabled)
                }
            default:
                completion(false)
            }
        })
    }
    
    func onAppStart() {
        PushType.enableAll()
    }
    
    enum PushType: CaseIterable {
        case threeDays
        case regular
        case everyday
        
        var components: DateComponents {
            var dateComponents = DateComponents()
            switch self {
            case .threeDays:
                dateComponents.day = 3
            case .regular:
                dateComponents.day = 2
                dateComponents.hour = 12
            case .everyday:
                dateComponents.hour = 9
            }
            return dateComponents
        }
        
        var repeats: Bool {
            return [.regular, .everyday].contains(self)
        }
        
        var content: UNMutableNotificationContent {
            let content = UNMutableNotificationContent()
            switch self {
            case .threeDays:
                content.title = "You haven't opened the 24Goals app in 3 days.".localized
                content.body = "Click here and I'll show you what you started it all for.".localized
                content.userInfo = [
                    "type": String(NotificationType.threeDays.rawValue)
                ]
            case .regular:
                content.body = "Invite a friend or become an observer".localized
            case .everyday:
                content.body = "Everyday morning push".localized
            }
            return content
        }
        
        var canBeEnabled: Bool {
            guard PushNotificationsManager.shared.isNotificationsAllowed == true else { return false}
            switch self {
            case .threeDays:
                return ModuleUserDefaults.getIsLoggedIn()
            default:
                return true
            }
        }
        
        func enable() {
            guard self.canBeEnabled else { return }
            let notificationCenter = UNUserNotificationCenter.current()
            let uuidString = UUID().uuidString
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: self.components, repeats: self.repeats)
            let request = UNNotificationRequest(identifier: uuidString, content: self.content, trigger: trigger)
            notificationCenter.add(request) { (error) in
                if error != nil {
                    print(error as Any)
                }
            }
        }
        
        static func enableAll() {
            PushNotificationsManager.shared.notificationCenter.removeAllPendingNotificationRequests()
            for push in allCases {
                push.enable()
            }
        }
    }
}
