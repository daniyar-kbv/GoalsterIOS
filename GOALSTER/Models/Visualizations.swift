//
//  Visualizations.swift
//  GOALSTER
//
//  Created by Daniyar on 8/19/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

class Visualization: NSObject, Codable, NSCoding {
    var id: Int?
    var image: String?
    var annotation: String?
    
    enum CodingKeys: String, CodingKey {
        case id, image, annotation
    }
    
    init(id: Int?, image: String?, annotation: String?) {
        self.id = id
        self.image = image
        self.annotation = annotation
    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? Int
        let image = aDecoder.decodeObject(forKey: "image") as? String
        let annotation = aDecoder.decodeObject(forKey: "annotation") as? String
        self.init(id: id, image: image, annotation: annotation)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(annotation, forKey: "annotation")
    }
}

class SphereVisualization: Codable {
    var id: Int?
    var name: String?
    var visualizations: [Visualization]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, visualizations
    }
    
    init(id: Int?, name: String?, visualizations: [Visualization]?) {
        self.id = id
        self.name = name
        self.visualizations = visualizations
    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? Int
        let name = aDecoder.decodeObject(forKey: "name") as? String
        let visualizations = aDecoder.decodeObject(forKey: "visualizations") as? [Visualization]
        self.init(id: id, name: name, visualizations: visualizations)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(visualizations, forKey: "visualizations")
    }
}

class VisualizationsResponse: Codable {
    var spheres: [SphereVisualization]?
    
    enum CodingKeys: String, CodingKey {
        case spheres
    }
}
