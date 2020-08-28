//
//  Notifications.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class NotificationsResponse: Codable {
    var enabled: Bool?
    
    enum CodingKeys: String, CodingKey {
        case enabled
    }
}
