//
//  Feed.swift
//  GOALSTER
//
//  Created by Dan on 2/15/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation

class FeedUserSphere: Codable {
    var name: String?
    var description: String?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case name, description, count
    }
}

class Reaction: Codable {
    var id: Int?
    var emoji: String?
    var count: Int?
    var reacted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, emoji, count, reacted
    }
}

struct FeedUser: Codable {
    var id: Int?
    var profile: Profile?
    var selected: [FeedUserSphere]?
    var reactions: [Reaction]?
    var isCelebrity: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, profile, selected, reactions
        case isCelebrity = "is_celebrity"
    }
}

class FeedUserFull: Codable {
    var id: Int?
    var email: String?
    var profile: Profile?
    var selected: [FeedUserSphere]?
    var reactions: [Reaction]?
    var isFollowing: Bool?
    var goals: GoalsResponse?
    var isCelebrity: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, profile, selected, reactions, email, goals
        case isFollowing = "is_following"
        case isCelebrity = "is_celebrity"
    }
}

class FeedResponse: Codable {
    var results: [FeedUser]?
    var page: Int?
    var totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
    }
}
