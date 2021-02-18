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
    
    static let ultraPink = UIColor(hex: "#710FF4")
    static let ultraGray = UIColor(hex: "#0F0F0F")
    static let darkBlack = UIColor(hex: "#000000")
    static let deepBlue = UIColor(hex: "#313476")
    static let middleBlue = UIColor(hex: "#8E90BD")
    static let strongGray = UIColor(hex: "#A5A5A6")
    static let middlePink = UIColor(hex: "#9899BA")
    static let middleGray = UIColor(hex: "#BFBEC6")
    static let borderGray = UIColor(hex: "#D1D1D1")
    static let lightPink = UIColor(hex: "#BDBBC9")
    static let lightBlue = UIColor(hex: "#7F8297")
    static let softPink = UIColor(hex: "#D0D0E8")
    static let buttonPink = UIColor(hex: "#F3F4FF")
    static let wildGreen = UIColor(hex: "#00B412")
    static let calmGreen = UIColor(hex: "#67FF64")
    static let goodYellow = UIColor(hex: "#FFC700")
    static let greatRed = UIColor(hex: "#FF6464")
    static let backgroundGray = UIColor(hex: "#F9F9F9")
    static let arcticWhite = UIColor(hex: "#FFFFFF")
    static let lightBeige = UIColor(hex: "#FAF8F5")
    static let strongBeige = UIColor(hex: "#F9F0E3")
    static let arcticPink = UIColor(hex: "#EAE8FC")
    static let turnedOffGradientStart = UIColor(hex: "#B1A8D9")
    static let turnedOffGradientEnd = UIColor(hex: "#9C8CC3")
    static let buttonGradientStart = UIColor(hex: "#917FE3")
    static let buttonGradientEnd = UIColor(hex: "#5D3CB0")
    
    static let customBackDarkPurple = UIColor(hex: "#5333A3")
    static let customBackLightPurple = UIColor(hex: "#7D6CCD")
    static let customPurple = UIColor(hex: "#5C3FAC")
    static let customCalendarPurple = UIColor(hex: "#D0D0E8")
    static let iOSBlue = UIColor(hex: "#147EFB")
    static let iOSLightGray = UIColor(hex: "#ecf0f3")
    
    static let pinkGradient: [UIColor] = [.arcticPink, .arcticWhite]
    static let turnedOffGradient: [UIColor] = [.turnedOffGradientStart, .turnedOffGradientEnd]
    static let buttonGradient: [UIColor] = [.buttonGradientStart, .buttonGradientEnd]
    
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
