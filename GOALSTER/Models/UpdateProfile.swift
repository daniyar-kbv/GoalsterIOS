//
//  UodateProfile.swift
//  GOALSTER
//
//  Created by Dan on 2/2/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation

class RegisterResponse: Codable {
    var profile: Profile?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case profile, email
    }
}

class UpdateProfileResponse: RegisterResponse {
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case token
    }
}
