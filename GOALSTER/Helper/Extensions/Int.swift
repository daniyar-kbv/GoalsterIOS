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
}
