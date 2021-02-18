//
//  Int.swift
//  Samokat
//
//  Created by Daniyar on 7/8/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

extension Int {
    internal func toTime() -> String{
        let minutes = self / 60
        let seconds = self % 60
        return "\(minutes > 9 ? "\(minutes)" : "0\(minutes)"):\(seconds > 9 ? "\(seconds)" : "0\(seconds)")"
    }
    
    func toGoalsNumber() -> String {
        switch ModuleUserDefaults.getLanguage() {
        case .en:
            return self == 1 ?
                "\(self) goal" :
                "\(self) goals"
        case .ru:
            switch Int(String(String(self).last ?? String.Element(""))) {
            case 1:
                return "\(self) цель"
            case 2, 3, 4:
                return "\(self) цели"
            case 5, 6, 7, 8, 9, 0:
                return "\(self) целей"
            default:
                return ""
            }
        }
    }
}
