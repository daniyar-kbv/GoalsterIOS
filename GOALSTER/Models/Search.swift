//
//  Search.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class User: Codable {
    var id: Int?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email
    }
}

class SearchResponse: Codable {
    var users: [User]?
    
    enum CodingKeys: String, CodingKey {
        case users
    }
}
