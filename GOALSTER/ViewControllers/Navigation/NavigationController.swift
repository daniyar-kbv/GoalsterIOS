//
//  NavigationController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class NavigationController: UINavigationController {
    lazy var disposeBag = DisposeBag()
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        self.isNavigationBarHidden = true
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.ultraGray]
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        bind()
    }
    
    func bind() {
        AppShared.sharedInstance.profileSubject.subscribe(onNext: { object in
            DispatchQueue.main.async {
                if object == nil && !(UIApplication.topViewController() is LaunchScreenViewController) {
                    self.popToRootViewController(animated: false)
                    self.pushViewController(NeedProfileViewController(), animated: true)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

