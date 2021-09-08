//
//  Auth.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

struct AuthResponse: Codable {
    var token: String?
    var hasSpheres: Bool?
    var spheres: [SelectedSphere]?
    var email: String?
    var profile: Profile?
    var isPremium: Bool?
    var premiumType: String?
    var premiumEndDate: String?
    var notConfirmedCount: Int?
    var emailed: Bool?
    var showResults: Bool?
    var periodicNotifications: [PeriodicNotification]
    var nonCustomizableNotifications: [NonCustomizableNotification]
    
    enum CodingKeys: String, CodingKey {
        case token, hasSpheres, spheres, email, profile, isPremium, notConfirmedCount, premiumType, premiumEndDate, emailed, showResults
        case periodicNotifications = "periodic_notifications"
        case nonCustomizableNotifications = "non_customizable_notifications"
    }
}

class Profile: NSObject, Codable, NSCoding {
    var id: Int?
    var name: String?
    var specialization: String?
    var instagramUsername: String?
    var avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, specialization, avatar
        case instagramUsername = "instagram_username"
    }
    
    init(id: Int?, name: String?, specialization: String?, instagramUsername: String?, avatar: String?) {
        self.id = id
        self.name = name
        self.specialization = specialization
        self.instagramUsername = instagramUsername
        self.avatar = avatar
    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? Int
        let name = aDecoder.decodeObject(forKey: "name") as? String
        let specialization = aDecoder.decodeObject(forKey: "specialization") as? String
        let instagramUsername = aDecoder.decodeObject(forKey: "instagramUsername") as? String
        let avatar = aDecoder.decodeObject(forKey: "avatar") as? String
        self.init(id: id, name: name, specialization: specialization, instagramUsername: instagramUsername, avatar: avatar)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(specialization, forKey: "specialization")
        aCoder.encode(instagramUsername, forKey: "instagramUsername")
        aCoder.encode(avatar, forKey: "avatar")
    }
}

class SendCodeResponse: Codable {
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case email
    }
}
