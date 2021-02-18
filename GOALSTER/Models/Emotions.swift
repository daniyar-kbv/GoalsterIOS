//
//  Emotions.swift
//  GOALSTER
//
//  Created by Daniyar on 8/18/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class EmotionAnswer: NSObject, Codable, NSCoding {
    var id: Int?
    var question: String?
    var answer: String?
    
    enum CodingKeys: String, CodingKey {
        case id, question, answer
    }
    
    init(id: Int?, question: String?, answer: String?) {
        self.id = id
        self.question = question
        self.answer = answer
    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? Int
        let question = aDecoder.decodeObject(forKey: "question") as? String
        let answer = aDecoder.decodeObject(forKey: "answer") as? String
        self.init(id: id, question: question, answer: answer)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(question, forKey: "question")
        aCoder.encode(answer, forKey: "answer")
    }
}
    
class EmotionsResponse: Codable {
    var emotions: [EmotionAnswer]?
    
    enum CodingKeys: String, CodingKey {
        case emotions
    }
}
