//
//  Comment.swift
//  GOALSTER
//
//  Created by Dan on 2/11/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var id: Int?
    var createdAt: String?
    var sender: User?
    var text: String?
    var isOwner: Bool?
    var isRead: Bool?
    var isSent: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case id, sender, text
        case createdAt = "created_at"
        case isOwner = "is_owner"
        case isRead = "is_read"
    }
}

class CreateCommentResponse: Codable {
    var id: Int?
    var goal: Int?
    var text: String?
    
    enum CodingKeys: String, CodingKey {
        case id, goal, text
    }
}
