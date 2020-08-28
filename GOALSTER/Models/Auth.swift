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
    var spheres: [SelectedSphere]?
    
    enum CodingKeys: String, CodingKey {
        case token, spheres
    }
}
