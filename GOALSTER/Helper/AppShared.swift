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
    var openedKeyboardSize: CGRect? 
    var keyboardInitialSize: CGRect?
    
    var notificationTypeSubject = PublishSubject<NotificationType>()
    var notificationType: NotificationType? {
        didSet {
            guard let type = notificationType else { return }
            notificationTypeSubject.onNext(type)
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
}
