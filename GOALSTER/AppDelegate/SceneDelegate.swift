//
//  SceneDelegate.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
        let window = UIWindow(windowScene: windowScene)
        AppShared.sharedInstance.keyWindow = window
        let vc = LaunchScreenViewController() 
        let nav = NavigationController(rootViewController: vc)
        AppShared.sharedInstance.navigationController = nav
        window.rootViewController = nav // Your initial view controller.
        window.makeKeyAndVisible()
        self.window = window
        
        if let activity = connectionOptions.userActivities.first(where: { $0.webpageURL != nil }) {
            AppShared.sharedInstance.deeplinkURL = activity.webpageURL
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        SceneDelegate.shareLinkHandling(userActivity.webpageURL!)
    }
    
    static func shareLinkHandling(_ inCommingURL: URL) {
        print("url: \(inCommingURL)")
        let _ = DynamicLinks.dynamicLinks().handleUniversalLink(inCommingURL) { (dynamiclink, error) in
            guard error == nil else {
                print("Found an error: \(error?.localizedDescription ?? "")")
                return
            }
            print("Dynamic link : \(String(describing: dynamiclink?.url))")
            if let typeInt = Int(inCommingURL.getQueryStringParameter(param: "type") ?? ""), let type = DeepLinkType(rawValue: typeInt), let email = inCommingURL.getQueryStringParameter(param: "email"){
                openDeepLink(type: type, email: email)
            } else if let typeInt = Int(dynamiclink?.url?.getQueryStringParameter(param: "type") ?? ""), let type = DeepLinkType(rawValue: typeInt), let email = dynamiclink?.url?.getQueryStringParameter(param: "email"){
                openDeepLink(type: type, email: email)
            }
        }
    }
        
    static func openDeepLink(type: DeepLinkType, email: String){
        switch type {
        case .auth:
            if !ModuleUserDefaults.getIsLoggedIn() {
                UIApplication.topViewController()?.dismiss(animated: true, completion: {
                    SpinnerView.showSpinnerView()
                    APIManager.shared.auth(email: email) { error, response in
                        SpinnerView.completion = {
                            guard let response = response else {
                                print(error)
                                ErrorView.addToView(view: UIApplication.topViewController()?.view, text: error ?? "")
                                return
                            }
                            AppShared.sharedInstance.auth(response: response)
                            if !(response.spheres?.count == 3) {
                                AppShared.sharedInstance.tabBarController.toTab(tab: 0)
                                UIApplication.topViewController()?.present(SpheresListViewController(), animated: true, completion: nil)
                            }
                        }
                        SpinnerView.removeSpinnerView()
                    }
                })
            } else {
                UIApplication.topViewController()?.showAlertOk(title: "You're already logged in".localized)
            }
        case .premium:
            if email == ModuleUserDefaults.getEmail() {
                AppShared.sharedInstance.tabBarController.toTab(tab: 4)
                if !ModuleUserDefaults.getIsPremium() {
                    DispatchQueue.main.async {
                        let vc = ProfilePremiumViewController()
                        vc.setOnSuccess(onSuccess: {
                            AppShared.sharedInstance.navigationController.popViewController(animated: true)
                            AppShared.sharedInstance.navigationController.pushViewController(ObservedViewController(), animated: true)
                        })
                        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    AppShared.sharedInstance.navigationController.pushViewController(ObservedViewController(), animated: true)
                }
            }
        }
    }
}

