//
//  UIColor.swift
//  Samokat
//
//  Created by Daniyar on 7/7/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
//  MARK: Colors
    
    static let customBackPink = UIColor(hex: "#EAE8FC")
    static let customTextBlack = UIColor(hex: "#0F0F0F")
    static let customTextDarkPurple = UIColor(hex: "#313476")
    static let customBackDarkPurple = UIColor(hex: "#5333A3")
    static let customBackLightPurple = UIColor(hex: "#7D6CCD")
    static let customLightGray = UIColor(hex: "#A5A5A6")
    static let customPurple = UIColor(hex: "#5C3FAC")
    static let customGoalRed = UIColor(hex: "#FF6464")
    static let customGoalYellow = UIColor(hex: "#FFDD64")
    static let customGoalGreen = UIColor(hex: "#67FF64")
    static let customActivePurple = UIColor(hex: "#710FF4")
    static let customCalendarPurple = UIColor(hex: "#D0D0E8")
    static let customLightRed = UIColor(hex: "#FF6464")
    static let iOSBlue = UIColor(hex: "#147EFB")
    static let iOSLightGray = UIColor(hex: "#ecf0f3")
    
//  MARK: Methods
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        if (hex.hasPrefix("#")) {
            scanner.currentIndex = String.Index(utf16Offset: 1, in: hex)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
