//
//  Goals.swift
//  GOALSTER
//
//  Created by Daniyar on 8/16/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class Goal: Codable {
    var id: Int?
    var name: String?
    var time: TimeOfTheDay?
    var isDone: Bool?
    var observer: String?
    var sphere: SphereNumber?
    var isConfirmed: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case time
        case isDone = "is_done"
        case observer
        case sphere
        case isConfirmed = "is_confirmed"
    }
}

class GoalsResponse: Codable {
    var goals: Bool?
    var morning: [Goal]?
    var day: [Goal]?
    var evening: [Goal]?
    
    enum CodingKeys: String, CodingKey {
        case goals, morning, day, evening
    }
}

class CalendarGoals: Codable {
    var first: Bool?
    var second: Bool?
    var third: Bool?
    
    enum CodingKeys: String, CodingKey {
        case first, second, third
    }
}

class CaledarItem: Codable {
    var date: String?
    var goals: CalendarGoals?
    
    enum CodingKeys: String, CodingKey {
        case date, goals
    }
}

class CalendarResponse: Codable {
    var items: [CaledarItem]?
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

class TotalGoals: Codable{
    var first: Int?
    var second: Int?
    var third: Int?
    
    enum CodingKeys: String, CodingKey {
        case first, second, third
    }
}

class TodayGoalsResponse: Codable {
    var total: TotalGoals?
    var goals: GoalsResponse?
    
    enum CodingKeys: String, CodingKey {
        case total, goals
    }
}
