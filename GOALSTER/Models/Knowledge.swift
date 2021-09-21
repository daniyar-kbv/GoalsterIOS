//
//  Knowledge.swift
//  GOALSTER
//
//  Created by Dan on 9/20/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation

struct KnowledgeSection: Codable {
    let id: Int
    let name: String
    let image: URL?
    
    init(id: Int, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = URL(string: image)
    }
}


struct KnowledgeStory: Codable {
    let id: Int
    let text: String
    let image: URL?
    let link: URL?
    
    init(id: Int, text: String, image: String, link: String) {
        self.id = id
        self.text = text
        self.image = URL(string: image)
        self.link = URL(string: link)
    }
}
