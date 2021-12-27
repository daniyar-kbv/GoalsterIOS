//
//  Notifications.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class NotificationsResponse: Codable {
    var enabled: Bool?
    
    enum CodingKeys: String, CodingKey {
        case enabled
    }
}

protocol InternalNotificationType {
    var titleEN: String { get }
    var titleRU: String { get }
    var bodyEN: String? { get }
    var bodyRU: String? { get }
}

struct PeriodicNotification: InternalNotificationType, Codable {
    let titleEN: String
    let titleRU: String
    let bodyEN: String?
    let bodyRU: String?
    let weekdays: [Int]
    let time: String
    
    enum CodingKeys: String, CodingKey {
        case weekdays, time
        case titleEN = "title_en"
        case titleRU = "title_ru"
        case bodyEN = "body_en"
        case bodyRU = "body_ru"
    }
}

struct NonCustomizableNotification: InternalNotificationType, Codable {
    let titleEN: String
    let titleRU: String
    let bodyEN: String?
    let bodyRU: String?
    let type: Type?
    
    init(titleEN: String, titleRU: String, bodyEN: String?, bodyRU: String?, type: Int) {
        self.titleEN = titleEN
        self.titleRU = titleRU
        self.bodyEN = bodyEN
        self.bodyRU = bodyRU
        self.type = Type(rawValue: type)
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case titleEN = "title_en"
        case titleRU = "title_ru"
        case bodyEN = "body_en"
        case bodyRU = "body_ru"
    }
    
    enum `Type`: Int, Codable {
        case threeDays = 1
        case completeGoals = 7
    }
}
