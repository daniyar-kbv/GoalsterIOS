//
//  Search.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class User: NSObject, Codable, NSCoding {
    var id: Int?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email
    }
    
    init(id: Int?, email: String?) {
        self.id = id
        self.email = email
    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? Int
        let email = aDecoder.decodeObject(forKey: "email") as? String
        self.init(id: id, email: email)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
    }
}

class SearchResponse: Codable {
    var users: [User]?
    
    enum CodingKeys: String, CodingKey {
        case users
    }
}
