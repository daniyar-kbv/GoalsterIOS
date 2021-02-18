//
//  AppDelegate.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import UIKit
import AlamofireEasyLogger
import Firebase
import FirebaseMessaging
import FirebaseDynamicLinks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let reachibilityHandler = ReachabilityHandler()
    let alamofireLogger = FancyAppAlamofireLogger(
        logFunction: {
            print($0)
        }
    )

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
    
        UNUserNotificationCenter.current().delegate = self

        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
          }
        }
        
        DynamicLinks.performDiagnostics(completion: nil)
        
        configData()
        configNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func configData() {
        AppShared.sharedInstance.selectedSpheres = ModuleUserDefaults.getSpheres()
        UIApplication.setNotificationBadge(count: 0)
    }
    
    func configNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        notificationCenter.removeAllPendingNotificationRequests()
        
        let inviteContent = UNMutableNotificationContent()
        inviteContent.title = "Invite a friend or become an observer".localized
        
        for weekday in [1, 4] {
            var dateComponents = DateComponents()
            dateComponents.calendar = calendar
            dateComponents.weekday = weekday
            dateComponents.hour = 12
            dateComponents.minute = 0
    
            let trigger = UNCalendarNotificationTrigger(
                     dateMatching: dateComponents, repeats: true)
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString,
                        content: inviteContent, trigger: trigger)
            
            notificationCenter.add(request) { (error) in
                if error != nil {
                    print(error as Any)
                }
            }
        }
        
        if ModuleUserDefaults.getIsLoggedIn() {
            let threeDaysContent = UNMutableNotificationContent()
            threeDaysContent.title = "You haven't opened the 24Goals app in 3 days.".localized
            threeDaysContent.body = "Click here and I'll show you what you started it all for.".localized
            threeDaysContent.userInfo = [
                "type": String(NotificationType.threeDays.rawValue)
            ]
            
            var dateComponents = DateComponents()
            dateComponents.day = 3
//            dateComponents.second = 5

            let trigger = UNCalendarNotificationTrigger(
                     dateMatching: dateComponents, repeats: false)
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString,
                        content: threeDaysContent, trigger: trigger)

            notificationCenter.add(request) { (error) in
                if error != nil {
                    print(error as Any)
                }
            }
        }
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
        // ...
      }

      return handled
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return application(app, open: url,
                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                         annotation: "")
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
        // Handle the deep link. For example, show the deep-linked content or
        // apply a promotional offer to the user's account.
        // ...
        return true
      }
      return false
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        ModuleUserDefaults.setFCMToken(fcmToken)
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }

    //Present in app
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        print(content.userInfo)
        let vc = UIApplication.topViewController()
        vc?.showAlertOk(title: content.title, messsage: content.body, okCompletion: { _ in
            AppShared.sharedInstance.notification = content
        })
    }

    //On tap
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content = response.notification.request.content
        print(content.userInfo)
        AppShared.sharedInstance.notification = content
        completionHandler()
    }
}

