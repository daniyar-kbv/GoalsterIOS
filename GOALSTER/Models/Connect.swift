//
//  Connect.swift
//  GOALSTER
//
//  Created by Daniyar on 8/13/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

//class MySphere: Codable {
//    var id: Int?
//    var name: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//    }
//}

class ConnectResponse: Codable {
    var hasSpheres: Bool?
    var email: String?
    var isPremium: Bool?
    var notConfirmedCount: Int?
//    var spheres: [MySphere]?
    
    enum CodingKeys: String, CodingKey {
        case hasSpheres, email, isPremium, notConfirmedCount
    }
}
