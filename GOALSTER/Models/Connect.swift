//
//  Connect.swift
//  GOALSTER
//
//  Created by Daniyar on 8/13/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class ConnectResponse: Codable {
    var token: String?
    var hasSpheres: Bool?
    var spheres: [SelectedSphere]?
    var email: String?
    var isPremium: Bool?
    var premiumType: String?
    var notConfirmedCount: Int?
    var premiumEndDate: String?
    var profile: Profile?
    var showResults: Bool?
    
    enum CodingKeys: String, CodingKey {
        case token, hasSpheres, spheres, email, isPremium, notConfirmedCount, premiumType, premiumEndDate, profile, showResults
    }
}
