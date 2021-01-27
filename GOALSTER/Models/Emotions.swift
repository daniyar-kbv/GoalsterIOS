//
//  Emotions.swift
//  GOALSTER
//
//  Created by Daniyar on 8/18/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class EmotionAnswer: Codable {
    var id: Int?
    var question: String?
    var answer: String?
    
    enum CodingKeys: String, CodingKey {
        case id, question, answer
    }
}
    
class EmotionsResponse: Codable {
    var emotions: [EmotionAnswer]?
    
    enum CodingKeys: String, CodingKey {
        case emotions
    }
}
