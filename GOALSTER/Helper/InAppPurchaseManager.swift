//
//  InAppPurchaseManager.swift
//  GOALSTER
//
//  Created by Dan on 9/28/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import StoreKit
import RxSwift
import RxCocoa

class InAppPurchaseManager: NSObject {
    static let shared = InAppPurchaseManager()
    
    private override init() {
        super.init()
    }
    
    private let productTypes: [ProductType] = [.oneMonth, .oneYear]
    private var products: [SKProduct]?
    
    let didGetProducts = PublishRelay<[(identifier: String, price: String)]>()
    let didMakePayment = PublishRelay<(identifier: String, date: Date, productType: ProductType)>()
    
    func getProducts() {
        guard let products = products else {
            fetchProducts()
            return
        }
        
        didGetProducts.accept(products.map({
            ($0.productIdentifier, $0.localizedPrice)
        }))
    }
}

extension InAppPurchaseManager: SKProductsRequestDelegate {
    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(productTypes.map({ $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
            
            self.didGetProducts.accept(response.products.map({
                ($0.productIdentifier, $0.localizedPrice)
            }))
        }
    }
}

extension InAppPurchaseManager: SKPaymentTransactionObserver {
    func makePayment(identifier: String) {
        guard let product = products?.first(where: { $0.productIdentifier == identifier }) else { return }
        DispatchQueue.main.async {
            if SKPaymentQueue.canMakePayments() {
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(payment)
            }
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
                if let productType = ProductType(rawValue: transaction.payment.productIdentifier),
                   let identifier = transaction.transactionIdentifier,
                   let date = transaction.transactionDate {
                    didMakePayment.accept((identifier, date, productType))
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
