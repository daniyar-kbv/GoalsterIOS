//
//  SKProduct.swift
//  GOALSTER
//
//  Created by Daniyar on 9/7/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import StoreKit

extension SKProduct {
    fileprivate static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }

    var localizedPrice: String {
        if self.price == 0.00 {
            return "Get"
        } else {
            let formatter = SKProduct.formatter
            formatter.locale = self.priceLocale
            
            switch formatter.currencyCode {
            case "KZT":
                return "\(self.price.doubleValue.formattedWithSeparator)₸"
            default:
                return "\(self.price.doubleValue.formattedWithSeparator) \(formatter.currencyCode ?? "")"
            }
        }
    }
    
    var buttonTitle: String {
        return "\(self.localizedTitle.localized)/\(self.localizedPrice)"
    }
}
