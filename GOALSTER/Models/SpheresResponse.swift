//
//  SpheresResponse.swift
//  GOALSTER
//
//  Created by Daniyar on 8/13/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class SelectedSphere: NSObject, Codable, NSCoding {
    var id: Int?
    var sphere: String?
    var description_: String?
    
    enum CodingKeys: String, CodingKey {
        case id, sphere
        case description_ = "description"
    }
    
    init(id: Int?, sphere: String?, description_: String?) {
        self.id = id
        self.sphere = sphere
        self.description_ = description_
    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? Int
        let sphere = aDecoder.decodeObject(forKey: "sphere") as? String
        let description_ = aDecoder.decodeObject(forKey: "description_") as? String
        self.init(id: id, sphere: sphere, description_: description_)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(sphere, forKey: "sphere")
        aCoder.encode(description_, forKey: "description_")
    }
}

class ChooseSpheresResponse: Codable {
    var spheres: [SelectedSphere]?
    
    enum CodingKeys: String, CodingKey {
        case spheres
    }
}
