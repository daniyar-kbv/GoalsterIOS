//
//  PayBallController.swift
//  GOALSTER
//
//  Created by Dan on 9/21/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PayBallController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = PayBallView()
    private let viewModel = PremiumViewModel()
    
    private var plans = [(identifier: String, price: String)]()
    var onSuccess: (() -> Void)?
    var onBack: (() -> Void)? {
        didSet {
            contentView.backButton.onBack = onBack
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        contentView.buttonTapped = makePayment(type:)
        enablePanGesture()
        bind()
        
        contentView.showSpinnerViewCenter()
        InAppPurchaseManager.shared.getProducts()
    }
    
    private func bind() {
        viewModel.success.subscribe(onNext: { [weak self] _ in
            self?.finishPayment()
        }).disposed(by: disposeBag)
        
        InAppPurchaseManager.shared
            .didGetProducts
            .subscribe(onNext: { [weak self] products in
                self?.process(products: products)
            })
            .disposed(by: disposeBag)
        
        InAppPurchaseManager.shared
            .didMakePayment
            .subscribe(onNext: { [weak self] transaction in
                self?.process(transaction: transaction)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func backTapped() {
        onBack?()
    }
    
    func hideTopBrush() {
        contentView.topBrush.isHidden = true
    }
    
    func hideBackButton() {
        contentView.backButton.isHidden = true
    }
    
    private func process(products: [(identifier: String, price: String)]) {
        SpinnerView.removeSpinnerView()
        
        let plans = products
            .compactMap({ product -> (type: PlanView.PlanType, price: String)? in
                guard let planType = PlanView.PlanType(rawValue: product.identifier)
                else { return nil }
                return (
                    type: planType,
                    price: product.price
                )
            })
        
        self.contentView.setUp(plans: plans)
    }
    
    private func process(transaction: (identifier: String, date: Date, productType: ProductType)) {
        guard let productType = ProductType(rawValue: transaction.identifier) else { return }
        viewModel.premium(identifier: transaction.identifier,
                          date: transaction.date,
                          productType: productType)
    }
    
    private func finishPayment() {
        showAlertOk(title: "Premium successfully purchased".localized, messsage: nil, okCompletion: { _ in
            self.onSuccess?()
        })
    }
    
    private func makePayment(type: PlanView.PlanType) {
        SpinnerView.showSpinnerView()
        InAppPurchaseManager.shared.makePayment(identifier: type.rawValue)
    }
}

extension PayBallController: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    private func enablePanGesture() {
        AppShared.sharedInstance.navigationController.delegate = self
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.delegate = self
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is NavigationMenuBaseController {
            AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = false
            AppShared.sharedInstance.navigationController.delegate = nil
        }
    }
}
