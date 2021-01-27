//
//  Error.swift
//  Samokat
//
//  Created by Daniyar on 7/15/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class ErrorResponse: Codable  {
    var messages: [String]?
    
    enum CodingKeys: String, CodingKey {
        case messages
    }
    
    func getFirst() -> String? {
        return messages?.first
    }
}
