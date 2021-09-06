//
//  UIFont.swift
//  Samokat
//
//  Created by Daniyar on 7/7/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    class func primary(ofSize: CGFloat, weight: FontStyles) -> UIFont {
        guard let font = UIFont(name: weight.rawValue, size: ofSize) else { return .systemFont(ofSize: ofSize) }
        return font
    }
    
    class func secondary(ofSize: CGFloat, weight: SecondaryFontStyles) -> UIFont {
        guard let font = UIFont(name: weight.rawValue, size: ofSize) else { return .systemFont(ofSize: ofSize) }
        return font
    }
}
