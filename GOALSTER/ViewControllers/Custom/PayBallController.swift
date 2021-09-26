//
//  PayBallController.swift
//  GOALSTER
//
//  Created by Dan on 9/21/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import RxSwift
import RxCocoa

class PayBallController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = PayBallView()
    private let viewModel = PremiumViewModel()
    
    var products = [SKProduct]()
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
        fetchProducts()
        bind()
    }
    
    private func bind() {
        viewModel.success.subscribe(onNext: { [weak self] _ in
            self?.finishPayment()
        }).disposed(by: disposeBag)
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

extension PayBallController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    private func finishPayment() {
        showAlertOk(title: "Premium successfully purchased".localized, messsage: nil, okCompletion: { _ in
            self.onSuccess?()
        })
    }
    
    private func makePayment(type: PayBallView.PlanView.PlanType) {
        guard let product = products.first(where: { $0.productIdentifier == type.rawValue }) else { return }
        DispatchQueue.main.async {
            if SKPaymentQueue.canMakePayments() {
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(payment)
                SpinnerView.showSpinnerView()
            }
        }
    }
    
    private func fetchProducts() {
        contentView.showSpinnerViewFull()
        let request = SKProductsRequest(productIdentifiers: Set(ProductType.allCases.map({ $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
            
            SpinnerView.removeSpinnerView()
            
            let plans = response.products
                .compactMap({ product -> (type: PayBallView.PlanView.PlanType, price: String)? in
                    guard let planType = PayBallView.PlanView.PlanType(rawValue: product.productIdentifier)
                    else { return nil }
                    return (
                        type: planType,
                        price: product.localizedPrice
                    )
                })
            
            print(plans)
            
            self.contentView.setUp(plans: plans)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if [SKPaymentTransactionState.purchased, SKPaymentTransactionState.restored, SKPaymentTransactionState.failed, SKPaymentTransactionState.deferred].contains(transaction.transactionState) {
                SpinnerView.removeSpinnerView()
            }
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                if let productType = ProductType(rawValue: transaction.payment.productIdentifier), let identifier = transaction.transactionIdentifier, let date = transaction.transactionDate {
                    self.viewModel.premium(identifier: identifier, date: date, productType: productType)
                }
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
            }
        }
    }
}
