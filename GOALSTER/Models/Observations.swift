//
//  Observations.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class Observed: Codable {
    var id: Int?
    var observed: String?
    var isConfirmed: Bool?
    var spheres: String?
    
    enum CodingKeys: String, CodingKey {
        case spheres, id, observed
        case isConfirmed = "is_confirmed"
    }
}

class ObservedResponse: Codable {
    var observed: [Observed]?
    
    enum CodingKeys: String, CodingKey {
        case observed
    }
}

class Observer: Codable {
    var id: Int?
    var observer: String?
    var isConfirmed: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, observer
        case isConfirmed = "is_confirmed"
    }
}

class ObserversResponse: Codable {
    var observers: [Observer]?
    
    enum CodingKeys: String, CodingKey {
        case observers
    }
}
