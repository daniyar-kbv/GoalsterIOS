//
//  Visualizations.swift
//  GOALSTER
//
//  Created by Daniyar on 8/19/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class Visualization: Codable {
    var id: Int?
    var image: String?
    var annotation: String?
    
    enum CodingKeys: String, CodingKey {
        case id, image, annotation
    }
}

class SphereVisualization: Codable {
    var id: Int?
    var name: String?
    var visualizations: [Visualization]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, visualizations
    }
}

class VisualizationsResponse: Codable {
    var spheres: [SphereVisualization]?
    
    enum CodingKeys: String, CodingKey {
        case spheres
    }
}
