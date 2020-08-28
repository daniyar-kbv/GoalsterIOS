//
//  Date.swift
//  GOALSTER
//
//  Created by Daniyar on 8/16/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

extension Date {
    func format(format: String = "dd-MM-yyyy") -> String {
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = format
        return dateFormatterOut.string(from: self)
    }
    
    func getDayOfWeek() -> DayOfWeek? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        if let day = DayOfWeek(rawValue: weekDay) {
            return day
        }
        return nil
    }
}
