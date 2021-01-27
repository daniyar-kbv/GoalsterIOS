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
    
    var productIdsOrder: [(key: String, value: Int)] = [(key:"com.goalsterapp.threemonth", value: 0), (key: "com.goalsterapp.sixmonth", value: 1), (key: "com.goalsterapp.oneyear", value: 2)]
    
    var success: Bool? {
        didSet {
            if parent is ProfilePremiumViewController{
                if let _ = parent?.parent as? AddGoalViewController, let p = parent as? ProfilePremiumViewController {
                    p.onSuccess?()
                } else {
                    parent?.dismiss(animated: true, completion: {
                        if let vc = UIApplication.topViewController() as? ProfileMainViewController {
                            vc.reload()
                        }
                    })
                }
            } else if parent is OnBoardingViewController {
                let vc = AppShared.sharedInstance.tabBarController
                parent?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    var products: [SKProduct]? {
        didSet {
            guard let products = products else { return }
            let sordedProducts = products.sorted(by: { product1, product2 in
                let order1 = self.productIdsOrder.first(
                    where: { prod in
                        prod.key == product1.productIdentifier
                    }
                )?.value
                let order2 = self.productIdsOrder.first(
                    where: {
                        prod in prod.key == product2.productIdentifier
                    }
                )?.value
                return order1! < order2!
            })
            for product in sordedProducts {
                let button: ProductButton = {
                    let view = ProductButton(product: product)
                    view.setTitle(product.buttonTitle, for: .normal)
                    view.titleLabel?.font = .gotham(ofSize: StaticSize.size(18), weight: .medium)
                    view.addTarget(self, action: #selector(makePayment(_:)), for: .touchUpInside)
                    if parent is OnBoardingViewController {
                        view.isUserInteractionEnabled = false
                    }
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
        bind()
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
        let request = SKProductsRequest(productIdentifiers: ["com.goalsterapp.threemonth", "com.goalsterapp.sixmonth", "com.goalsterapp.oneyear"])
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
