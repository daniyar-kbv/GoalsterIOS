//
//  Connect.swift
//  GOALSTER
//
//  Created by Daniyar on 8/13/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class ConnectResponse: Codable {
    var hasSpheres: Bool?
    var spheres: [SelectedSphere]?
    var email: String?
    var isPremium: Bool?
    var premiumType: String?
    var notConfirmedCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case hasSpheres, spheres, email, isPremium, notConfirmedCount, premiumType
    }
}
