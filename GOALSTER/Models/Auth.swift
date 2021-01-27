//
//  Auth.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class AuthResponse: Codable {
    var token: String?
    var hasSpheres: Bool?
    var spheres: [SelectedSphere]?
    var email: String?
    var isPremium: Bool?
    var premiumType: String?
    var notConfirmedCount: Int?
    var emailed: Bool?
    
    enum CodingKeys: String, CodingKey {
        case token, hasSpheres, spheres, email, isPremium, notConfirmedCount, premiumType, emailed
    }
}
