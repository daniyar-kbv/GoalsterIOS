////
////  Category.swift
////  Samokat
////
////  Created by Daniyar on 7/14/20.
////  Copyright © 2020 MTI. All rights reserved.
////
//
//import Foundation
//
//class CategoriesResponse: Codable {
//    var data: CategoriesData?
//    
//    enum CodingKeys: String, CodingKey {
//        case data
//    }
//}
//
//class CategoriesData: NSObject, Codable, NSCoding {
//    enum CategoriesDataStatus: String {
//        case modified = "MODIFIED"
//        case notModidied = "NOT_MODIFIED"
//    }
//    
//    var status: String?
//    var hash_: String?
//    var categories: [Category]?
//    
//    enum CodingKeys: String, CodingKey {
//        case categories
//        case status
//        case hash_ = "hash"
//    }
//    
//    init(status: String?, hash_: String?, categories: [Category]?) {
//        self.status = status
//        self.hash_ = hash_
//        self.categories = categories
//    }
//    
//    required convenience init(coder aDecoder: NSCoder) {
//        let status = aDecoder.decodeObject(forKey: "status") as? String
//        let hash_ = aDecoder.decodeObject(forKey: "hash_") as? String
//        let categories = aDecoder.decodeObject(forKey: "categories") as? [Category]
//        self.init(status: status, hash_: hash_, categories: categories)
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(status, forKey: "status")
//        aCoder.encode(hash_, forKey: "hash_")
//        aCoder.encode(categories, forKey: "categories")
//    }
//    
//    func getStatus() -> CategoriesDataStatus? {
//        return CategoriesDataStatus(rawValue: status ?? "")
//    }
//}
//
//class CategoryResponse: Codable {
//    var data: CategoryData?
//    
//    enum CodingKeys: String, CodingKey {
//        case data
//    }
//}
//
//class CategoryData: Codable {
//    var category: Category?
//    
//    enum CodingKeys: String, CodingKey {
//        case category
//    }
//}
//
//class Category: NSObject, Codable, NSCoding {
//    var id: Int?
//    var title: String?
//    var icon: String?
//    var bgColor: String?
//    var subCategories: [SubCategory]?
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case title, icon, bgColor
//        case subCategories
//    }
//    
//    init(id: Int?, title: String?, icon: String?, bgColor: String?, subCategories: [SubCategory]?) {
//        self.id = id
//        self.title = title
//        self.icon = icon
//        self.bgColor = bgColor
//        self.subCategories = subCategories
//    }
//    
//    required convenience init(coder aDecoder: NSCoder) {
//        let id = aDecoder.decodeObject(forKey: "id") as? Int
//        let title = aDecoder.decodeObject(forKey: "title") as? String
//        let icon = aDecoder.decodeObject(forKey: "icon") as? String
//        let bgColor = aDecoder.decodeObject(forKey: "bgColor") as? String
//        let subCategories = aDecoder.decodeObject(forKey: "subCategories") as? [SubCategory]
//        self.init(id: id, title: title, icon: icon, bgColor: bgColor, subCategories: subCategories)
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(title, forKey: "title")
//        aCoder.encode(icon, forKey: "icon")
//        aCoder.encode(bgColor, forKey: "bgColor")
//        aCoder.encode(subCategories, forKey: "subCategories")
//    }
//    
//    func getSubcategory(id: Int) -> SubCategory? {
//        guard let subCategories = subCategories else { return nil }
//        for sub in subCategories{
//            if sub.id == id {
//                return sub
//            }
//        }
//        return nil
//    }
//    
//    func getProduct(id: Int) -> Product? {
//        guard let subCategories = subCategories else { return nil }
//        var product: Product? = nil
//        for sub in subCategories{
//            if let found = sub.products?.first(where: {
//                $0.id == id
//            }) {
//                product = found
//            }
//        }
//        return product
//    }
//    
//    func search(text: String) -> [Product] {
//        guard let subCategories = subCategories else { return [] }
//        var found: [Product] = []
//        for sub in subCategories{
//            found.append(contentsOf: sub.products?.filter({
//                $0.details?.title?.lowercased().contains(text.lowercased()) ?? false
//            }) ?? [])
//        }
//        return found
//    }
//}
