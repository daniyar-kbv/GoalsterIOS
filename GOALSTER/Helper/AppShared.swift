//
//  AppShared.swift
//  Samokat
//
//  Created by Daniyar on 7/8/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AppShared {
    static let sharedInstance = AppShared()
    
    var appLoaded = false
    
    var keyWindow: UIWindow?
    var navigationController: UINavigationController!
    lazy var tabBarController = NavigationMenuBaseController()
    lazy var noInternetViewController = NoInternetViewController()
    
    lazy var openedKeyboardSizeSubject = PublishSubject<CGRect>()
    var openedKeyboardSize: CGRect? {
        didSet {
            guard let openedKeyboardSize = openedKeyboardSize else { return }
            openedKeyboardSizeSubject.onNext(openedKeyboardSize)
        }
    }
    var keyboardInitialSize: CGRect?
    
    var notificationSubject = PublishSubject<UNNotificationContent>()
    var notification: UNNotificationContent? {
        didSet {
            guard let notification = notification else { return }
            notificationSubject.onNext(notification)
        }
    }
    
    lazy var hasSpheresSubject = PublishSubject<Bool>()
    var hasSpheres: Bool? {
        didSet {
            guard let hasSpheres = hasSpheres else { return }
            hasSpheresSubject.onNext(hasSpheres)
        }
    }
    
    lazy var selectedSpheresSubject = PublishSubject<[SelectedSphere]?>()
    var selectedSpheres: [SelectedSphere]? {
        didSet {
            selectedSpheresSubject.onNext(selectedSpheres)
        }
    }
    
    var modalSelectedTime: TimeOfTheDay?
    var modalSelectedSphere: (SelectedSphere, Int)?
    
    lazy var doneGoalResponse = PublishSubject<Bool>()
    
    var deeplinkURL: URL?
    
    lazy var profileSubject = PublishSubject<Profile?>()
    var profile: Profile? = ModuleUserDefaults.getProfile() {
        didSet {
            profileSubject.onNext(profile)
            guard let profile = profile else { return }
            ModuleUserDefaults.setProfile(object: profile)
        }
    }
    
    lazy var goalsStatusSubject = PublishSubject<GoalsStatus?>()
    var goalsStatus = ModuleUserDefaults.getGoalsStatus() {
        didSet {
            ModuleUserDefaults.setGoalsStatus(object: goalsStatus)
            goalsStatusSubject.onNext(goalsStatus)
        }
    }
    
    lazy var totalGoalsSubject = PublishSubject<TotalGoals>()
    var totalGoals: TotalGoals? = ModuleUserDefaults.getTotalGoals() {
        didSet {
            guard let totalGoals = totalGoals else { return }
            totalGoalsSubject.onNext(totalGoals)
            ModuleUserDefaults.setTotalGoals(object: totalGoals)
        }
    }
    
    lazy var localCalendarSubject = PublishSubject<[LocalCalendarItem]>()
    var localCalendar: [LocalCalendarItem]? = ModuleUserDefaults.getLocalCalendar() {
        didSet {
            guard let localCalendar = localCalendar else { return }
            localCalendarSubject.onNext(localCalendar)
            ModuleUserDefaults.setLocalCalendar(object: localCalendar)
        }
    }
    
    lazy var emotionsSubject = PublishSubject<[EmotionAnswer]>()
    var emotions: [EmotionAnswer]? = ModuleUserDefaults.getEmotions() {
        didSet {
            guard let emotions = emotions else { return }
            emotionsSubject.onNext(emotions)
            ModuleUserDefaults.setEmotions(object: emotions)
        }
    }
    
    lazy var visualizationsSubject = PublishSubject<[SphereVisualization]>()
    var visualizations: [SphereVisualization]? = ModuleUserDefaults.getVisualizations() {
        didSet {
            guard let visualizations = visualizations else { return }
            visualizationsSubject.onNext(visualizations)
            ModuleUserDefaults.setVisualizations(object: visualizations)
        }
    }
    
    var followingVc: FeedViewController?
    var followedUser: FeedUserFull? {
        didSet {
            guard let user = followedUser, let vc = followingVc else { return }
            switch user.isFollowing ?? false {
            case true:
                if vc.mainView.tableView.numberOfRows(inSection: 0) == 0 {
                    vc.viewModel.feed(type: vc.type.rawValue)
                } else {
                    var users = vc.users
                    users.append(FeedUser(id: user.id, profile: user.profile, selected: user.selected, reactions: user.reactions))
                    vc.users = users
                    vc.viewModel.users = users
                }
            case false:
                if vc.mainView.tableView.numberOfRows(inSection: 0) == 0 {
                    vc.viewModel.feed(type: vc.type.rawValue)
                } else {
                    var users = vc.users
                    users.removeAll(where: { $0.id == user.id })
                    vc.users = users
                    vc.viewModel.users = users
                }
            }
        }
    }
    
    lazy var reaction = PublishSubject<(Int, Reaction)>()
    
    lazy var isLoggedInSubject = PublishSubject<Bool>()
    var isLoggedIn: Bool? {
        didSet {
            guard let isLoggedIn = isLoggedIn else { return }
            ModuleUserDefaults.setIsLoggedIn(isLoggedIn)
            isLoggedInSubject.onNext(isLoggedIn)
        }
    }
    
    func auth(response: AuthResponse) {
        if let token = response.token {
            ModuleUserDefaults.setToken(token)
            isLoggedIn = true
        }
        if let hasSpheres = response.hasSpheres {
            AppShared.sharedInstance.hasSpheres = hasSpheres
            ModuleUserDefaults.setHasSpheres(hasSpheres)
            if hasSpheres, let spheres = response.spheres {
                selectedSpheres = spheres
                ModuleUserDefaults.setSpheres(object: spheres)
            }
        }
        if let email = response.email {
            ModuleUserDefaults.setEmail(email)
        }
        if let isPremium = response.isPremium {
            ModuleUserDefaults.setIsPremium(isPremium)
        }
        if let premiumEndDate = response.premiumEndDate {
            ModuleUserDefaults.setPremiumEndDate(premiumEndDate)
        }
        if let showResults = response.showResults, showResults {
            let content = UNNotificationContent()
            content.setValue([
                "type": NotificationType.end.rawValue
            ], forKey: "userInfo")
            notification = content
        }
        profile = response.profile
        TrackerManager.setAdvancedMatching()
    }
}
