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
        dateFormatterOut.timeZone = TimeZone.current
        dateFormatterOut.dateFormat = format
        dateFormatterOut.locale = Locale(identifier: ModuleUserDefaults.getLanguage().localeIdentifier)
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
    
    func convertToTimeZone(initTimeZone: TimeZone = TimeZone(secondsFromGMT: 0)!, timeZone: TimeZone = TimeZone.current) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}
