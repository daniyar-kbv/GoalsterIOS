//
//  Results.swift
//  GOALSTER
//
//  Created by Daniyar on 9/2/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class Result: Codable {
    var sphereName: String?
    var number: Int?
    
    enum CodingKeys: String, CodingKey {
        case sphereName = "sphere_name"
        case number
    }
}

class ResultsResponse: Codable {
    var results: [Result]?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
