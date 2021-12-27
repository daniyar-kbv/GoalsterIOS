//
//  PushNotificationsManager.swift
//  GOALSTER
//
//  Created by Dan on 5/17/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class PushNotificationsManager {
    private let disposeBag = DisposeBag()
    static let shared = PushNotificationsManager()
    
    private init() {
        getNotificationsAllowed() { self.isNotificationsAllowed = $0 }
        
        bindAppShared()
    }
    
    let notificationCenter = UNUserNotificationCenter.current()
    private var notificationTypes: [InternalNotificationType]?
    
    var isNotificationsAllowed: Bool = ModuleUserDefaults.getIsNotificationsEnabled() {
        didSet {
            switch isNotificationsAllowed {
            case false:
                notificationCenter.removeAllPendingNotificationRequests()
            case true:
                reload()
            }
            ModuleUserDefaults.setIsNotificationsEnabled(isNotificationsAllowed)
        }
    }
    
    private func bindAppShared() {
        AppShared.sharedInstance.goalsStatusSubject
            .subscribe(onNext: { [weak self] _ in
                self?.reload()
            })
            .disposed(by: disposeBag)
        
        AppShared.sharedInstance.languageSubject
            .subscribe(onNext: { [weak self] _ in
                self?.reload()
            })
            .disposed(by: disposeBag)
    }
    
    private func reload() {
        guard let notificationTypes = notificationTypes else { return }
        set(notifications: notificationTypes)
    }
    
    func getNotificationsAllowed(_ completion: @escaping (Bool)->()){
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                guard ModuleUserDefaults.getIsLoggedIn() else {
                    completion(false)
                    return
                }
                APIManager.shared.getNotifications() { error, response in
                    completion(response?.enabled ?? false)
                }
            default:
                completion(false)
            }
        })
    }
    
    func set(notifications: [InternalNotificationType]) {
        guard isNotificationsAllowed else { return }
        
        notificationCenter.removeAllPendingNotificationRequests()
        notificationTypes = notifications
        
        notifications.forEach { notification in
            let content = UNMutableNotificationContent()
            var dateComponents = [DateComponents]()
            var repeats = false
            
            switch AppShared.sharedInstance.language {
            case .en:
                content.title = notification.titleEN
                content.body = notification.bodyEN ?? ""
            case .ru:
                content.title = notification.titleRU
                content.body = notification.bodyRU ?? ""
            }
            
            switch notification {
            case is PeriodicNotification:
                guard let notification = notification as? PeriodicNotification,
                      let date = notification.time.toDate(format: "HH:mm:ss") else { return }
                
                dateComponents = notification.weekdays.map { weekday -> DateComponents in
                    var components = DateComponents(calendar: .init(identifier: .gregorian))
                    components.weekday = weekday != 6 ? weekday + 2 : 1
                    components.hour = Calendar.current.component(.hour, from: date)
                    components.minute = Calendar.current.component(.minute, from: date)
                    return components
                }
                
                repeats = true
            case is NonCustomizableNotification:
                guard let notification = notification as? NonCustomizableNotification else { return }
                
                var components = DateComponents()
                
                switch notification.type {
                case .threeDays:
                    guard ModuleUserDefaults.getIsLoggedIn() else { return }
                    components.day = 3
                    content.userInfo = [
                        "type": String(NotificationType.threeDays.rawValue)
                    ]
                case .completeGoals:
                    guard ModuleUserDefaults.getIsLoggedIn(),
                          AppShared.sharedInstance.goalsStatus?.goals?.goals?.hasIncompleteGoals() ?? true
                    else { return }
                    components.hour = 21
                    content.userInfo = [
                        "type": String(NotificationType.completeGoals.rawValue)
                    ]
                default:
                    break
                }
                
                dateComponents = [components]
            default:
                break
            }
            
            let notificationCenter = UNUserNotificationCenter.current()
            let uuidString = UUID().uuidString
            
            dateComponents.forEach { components in
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                notificationCenter.add(request) { (error) in
                    if error != nil {
                        print(error as Any)
                    }
                }
            }
        }
    }
}
