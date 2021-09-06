//
//  Goals.swift
//  GOALSTER
//
//  Created by Daniyar on 8/16/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class Goal: NSObject, Codable, NSCoding {
    var id: Int?
    var name: String?
    var time: TimeOfTheDay?
    var isDone: Bool?
    var observer: User?
    var sphere: SphereNumber?
    var isConfirmed: Bool?
    var isPublic: Bool?
    var newComment: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case time
        case isDone = "is_done"
        case observer = "observer_data"
        case sphere
        case isConfirmed = "is_confirmed"
        case isPublic = "is_public"
        case newComment = "new_comment"
    }
    
    init(id: Int?, name: String?, time: TimeOfTheDay?, isDone: Bool?, observer: User?, sphere: SphereNumber?, isConfirmed: Bool?, isPublic: Bool?, newComment: Bool?) {
        self.id = id
        self.name = name
        self.time = time
        self.isDone = isDone
        self.observer = observer
        self.sphere = sphere
        self.isConfirmed = isConfirmed
        self.isPublic = isPublic
        self.newComment = newComment
    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? Int
        let name = aDecoder.decodeObject(forKey: "name") as? String
        let time = aDecoder.decodeObject(forKey: "time") as? Int
        let isDone = aDecoder.decodeObject(forKey: "isDone") as? Bool
        let observer = aDecoder.decodeObject(forKey: "observer") as? User
        let sphere = aDecoder.decodeObject(forKey: "sphere") as? Int
        let isConfirmed = aDecoder.decodeObject(forKey: "isConfirmed") as? Bool
        let isPublic = aDecoder.decodeObject(forKey: "isPublic") as? Bool
        let newComment = aDecoder.decodeObject(forKey: "newComment") as? Bool
        self.init(id: id, name: name, time: TimeOfTheDay(rawValue: time ?? 1), isDone: isDone, observer: observer, sphere: SphereNumber(rawValue: sphere ?? 1), isConfirmed: isConfirmed, isPublic: isPublic, newComment: newComment)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(time?.rawValue, forKey: "time")
        aCoder.encode(isDone, forKey: "isDone")
        aCoder.encode(observer, forKey: "observer")
        aCoder.encode(sphere?.rawValue, forKey: "sphere")
        aCoder.encode(isConfirmed, forKey:  "isConfirmed")
        aCoder.encode(isPublic, forKey:  "isPublic")
        aCoder.encode(newComment, forKey:  "newComment")
    }
}

class GoalsResponse: NSObject, Codable, NSCoding {
    var goals: Bool?
    var morning: [Goal]?
    var day: [Goal]?
    var evening: [Goal]?
    
    enum CodingKeys: String, CodingKey {
        case goals, morning, day, evening
    }
    
    init(goals: Bool?, morning: [Goal]?, day: [Goal]?, evening: [Goal]?) {
        self.goals = goals
        self.morning = morning
        self.day = day
        self.evening = evening
    }

    required convenience init(coder aDecoder: NSCoder) {
        let goals = aDecoder.decodeObject(forKey: "goals") as? Bool
        let morning = aDecoder.decodeObject(forKey: "morning") as? [Goal]
        let day = aDecoder.decodeObject(forKey: "day") as? [Goal]
        let evening = aDecoder.decodeObject(forKey: "evening") as? [Goal]
        self.init(goals: goals, morning: morning, day: day, evening: evening)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(goals, forKey: "goals")
        aCoder.encode(morning, forKey: "morning")
        aCoder.encode(day, forKey: "day")
        aCoder.encode(evening, forKey: "evening")
    }
}

class CalendarGoals: NSObject, Codable, NSCoding {
    var first: Bool?
    var second: Bool?
    var third: Bool?
    
    enum CodingKeys: String, CodingKey {
        case first, second, third
    }
    
    init(first: Bool?, second: Bool?, third: Bool?) {
        self.first = first
        self.second = second
        self.third = third
    }

    required convenience init(coder aDecoder: NSCoder) {
        let first = aDecoder.decodeObject(forKey: "first") as? Bool
        let second = aDecoder.decodeObject(forKey: "second") as? Bool
        let third = aDecoder.decodeObject(forKey: "third") as? Bool
        self.init(first: first, second: second, third: third)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(first, forKey: "first")
        aCoder.encode(second, forKey: "second")
        aCoder.encode(third, forKey: "third")
    }
}

class CaledarItem: NSObject, Codable, NSCoding {
    var date: String?
    var goals: CalendarGoals?
    
    enum CodingKeys: String, CodingKey {
        case date, goals
    }
    
    init(date: String?, goals: CalendarGoals?) {
        self.date = date
        self.goals = goals
    }

    required convenience init(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: "date") as? String
        let goals = aDecoder.decodeObject(forKey: "goals") as? CalendarGoals
        self.init(date: date, goals: goals)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(goals, forKey: "goals")
    }
}

class CalendarResponse: Codable {
    var items: [CaledarItem]?
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

class TotalGoals: NSObject, Codable, NSCoding {
    var first: Int?
    var second: Int?
    var third: Int?
    
    enum CodingKeys: String, CodingKey {
        case first, second, third
    }
    
    init(first: Int?, second: Int?, third: Int?) {
        self.first = first
        self.second = second
        self.third = third
    }

    required convenience init(coder aDecoder: NSCoder) {
        let first = aDecoder.decodeObject(forKey: "first") as? Int
        let second = aDecoder.decodeObject(forKey: "second") as? Int
        let third = aDecoder.decodeObject(forKey: "third") as? Int
        self.init(first: first, second: second, third: third)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(first, forKey: "first")
        aCoder.encode(second, forKey: "second")
        aCoder.encode(third, forKey: "third")
    }
}

class TodayGoalsResponse: NSObject, Codable, NSCoding {
    var total: TotalGoals?
    var goals: GoalsResponse?
    
    enum CodingKeys: String, CodingKey {
        case total, goals
    }
    
    init(total: TotalGoals?, goals: GoalsResponse?) {
        self.total = total
        self.goals = goals
    }

    required convenience init(coder aDecoder: NSCoder) {
        let total = aDecoder.decodeObject(forKey: "total") as? TotalGoals
        let goals = aDecoder.decodeObject(forKey: "goals") as? GoalsResponse
        self.init(total: total, goals: goals)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(total, forKey: "total")
        aCoder.encode(goals, forKey: "goals")
    }
}

class LocalCalendarItem: NSObject, NSCoding {
    var calendarItem: CaledarItem?
    var goalsResponse: GoalsResponse?
    
    init(calendarItem: CaledarItem?, goalsResponse: GoalsResponse?) {
        self.calendarItem = calendarItem
        self.goalsResponse = goalsResponse
    }

    required convenience init(coder aDecoder: NSCoder) {
        let calendarItem = aDecoder.decodeObject(forKey: "calendarItem") as? CaledarItem
        let goalsResponse = aDecoder.decodeObject(forKey: "goalsResponse") as? GoalsResponse
        self.init(calendarItem: calendarItem, goalsResponse: goalsResponse)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(calendarItem, forKey: "calendarItem")
        aCoder.encode(goalsResponse, forKey: "goalsResponse")
    }
}
