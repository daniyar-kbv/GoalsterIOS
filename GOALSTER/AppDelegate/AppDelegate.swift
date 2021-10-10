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
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let reachibilityHandler = ReachabilityHandler()
    let alamofireLogger = FancyAppAlamofireLogger(
        logFunction: {
            print($0)
        }
    )

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if !ModuleUserDefaults.getIsCleaned() {
            ModuleUserDefaults.clear()
            ModuleUserDefaults.setIsCleaned(true)
        }
        
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
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions:
            launchOptions
        )
        
        configData()
        
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
        DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            options: options
        )
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
//        print(content.userInfo)
        let vc = UIApplication.topViewController()
        vc?.showAlertOk(title: content.title, messsage: content.body, okCompletion: { _ in
            AppShared.sharedInstance.notification = content
        })
    }

    //On tap
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content = response.notification.request.content
//        print(content.userInfo)
        AppShared.sharedInstance.notification = content
        completionHandler()
    }
}

