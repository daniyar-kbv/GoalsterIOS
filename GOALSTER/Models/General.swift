//
//  General.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class GeneralResponse: Codable {
    
}

class PremiumPurchase: NSObject, NSCoding {
    var productType: ProductType?
    var identifier: String?
    var date: Date?
    
    init(productType: ProductType?, identifier: String?, date: Date?) {
        self.productType = productType
        self.identifier = identifier
        self.date = date
    }

    required convenience init(coder aDecoder: NSCoder) {
        let productType = aDecoder.decodeObject(forKey: "productType") as? ProductType
        let identifier = aDecoder.decodeObject(forKey: "identifier") as?  String
        let date = aDecoder.decodeObject(forKey: "date") as?  Date
        self.init(productType: productType, identifier: identifier, date: date)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(productType, forKey: "productType")
        aCoder.encode(identifier, forKey: "identifier")
        aCoder.encode(date, forKey: "date")
    }
}

class GoalsStatus: NSObject, NSCoding {
    var date: Date?
    var goals: TodayGoalsResponse?
    
    init(date: Date?, goals: TodayGoalsResponse?) {
        self.date = date
        self.goals = goals
    }

    required convenience init(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: "date") as? Date
        let goals = aDecoder.decodeObject(forKey: "goals") as? TodayGoalsResponse
        self.init(date: date, goals: goals)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(goals, forKey: "goals")
    }
}
