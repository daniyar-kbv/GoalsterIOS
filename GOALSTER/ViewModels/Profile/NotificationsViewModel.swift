//
//  NotificationsViewModel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift

class NotificationsViewModel {
    lazy var success = PublishSubject<Bool>()
    lazy var isOn = PublishSubject<Bool>()
    
    var view: UIView?
    
    var response: NotificationsResponse? {
        didSet {
            guard let isOn = response?.enabled else { return }
            self.isOn.onNext(isOn)
        }
    }
    
    func changeNotifications(isOn: Bool) {
        SpinnerView.showSpinnerView()
        APIManager.shared.changeNotifications(isOn: isOn) { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    return
                }
                self.success.onNext(response)
            }
            SpinnerView.removeSpinnerView()
        }
    }
    
    func getNotifications() {
        SpinnerView.showSpinnerView()
        APIManager.shared.getNotifications() { error, response in
            SpinnerView.completion = {
                guard let response = response else {
                    return
                }
                self.response = response
            }
            SpinnerView.removeSpinnerView()
        }
    }
}
