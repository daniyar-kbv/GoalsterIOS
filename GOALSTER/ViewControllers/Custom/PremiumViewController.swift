//
//  PremiumViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 9/3/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import RxSwift

class PremiumViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    lazy var premiumView = PremiumView()
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = PremiumViewModel()
    var viewForSpinner: UIView?
    
    var success: Bool? {
        didSet {
            if parent is ProfilePremiumViewController{
                parent?.dismiss(animated: true, completion: nil)
            } else if parent is OnBoardingViewController {
                let vc = AppShared.sharedInstance.tabBarController
                parent?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    var products: [SKProduct]? {
        didSet {
            guard let products = products else { return }
            for product in products {
                let button: ProductButton = {
                    let view = ProductButton(product: product)
                    view.setTitle(product.buttonTitle, for: .normal)
                    view.titleLabel?.font = .gotham(ofSize: StaticSize.size(18), weight: .medium)
                    view.addTarget(self, action: #selector(makePayment(_:)), for: .touchUpInside)
                    return view
                }()
                
                button.snp.makeConstraints({
                    $0.height.equalTo(StaticSize.buttonHeight)
                })
                
                premiumView.buttonsStack.addArrangedSubview(button)
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = premiumView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if parent is ProfilePremiumViewController {
            viewForSpinner = parent?.view
        }
        
        fetchProducts()
    }
    
    func bind() {
        viewModel.success.subscribe(onNext: { success in
            DispatchQueue.main.async {
                self.success = success
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func makePayment(_ sender: ProductButton) {
        DispatchQueue.main.async {
            if SKPaymentQueue.canMakePayments() {
                let payment = SKPayment(product: sender.product)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(payment)
                SpinnerView.showSpinnerView()
            }
        }
    }
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: ["com.goalsterapp.onemonth", "com.goalsterapp.threemonth", "com.goalsterapp.oneyear"])
        request.delegate = self
        request.start()
        SpinnerView.showSpinnerView(view: viewForSpinner)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            SpinnerView.removeSpinnerView()
            self.products = response.products
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState != .purchasing {
                SpinnerView.removeSpinnerView()
            }
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                if let productType = ProductType(rawValue: transaction.payment.productIdentifier), let identifier = transaction.transactionIdentifier, let date = transaction.transactionDate {
                    viewModel.premium(identifier: identifier, date: date, productType: productType)
                }
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
            }
        }
    }
}
