//
//  ModelUserDefaults.swift
//  Samokat
//
//  Created by Daniyar on 7/16/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

struct ModuleUserDefaults {
    private static let defaults = UserDefaults.standard
    
    static func setIsInitial(_ value: Bool){
        defaults.setValue(value, forKey: "isInitial")
    }
    
    static func getIsInitial() -> Bool{
        if let value = defaults.value(forKey: "isInitial"){
            if value as! Int == 1{
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    static func setIsLoggedIn(_ value: Bool){
        defaults.setValue(value, forKey: "isLoggedIn")
    }
    
    static func getIsLoggedIn() -> Bool{
        if let value = defaults.value(forKey: "isLoggedIn"){
            if value as! Int == 1{
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    static func setHasSpheres(_ value: Bool){
        defaults.setValue(value, forKey: "hasSpheres")
    }
    
    static func getHasSpheres() -> Bool{
        if let value = defaults.value(forKey: "hasSpheres"){
            if value as! Int == 1{
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    static func setLanguage(_ value: Language) {
        defaults.setValue(value.rawValue, forKey: "language")
    }
    
    static func getLanguage() -> Language {
        if let language = Language(rawValue: defaults.value(forKey: "language") as? String ?? "en") {
            return language
        }
        return .en
    }
    
    static func setToken(_ value: String) {
        defaults.setValue(value, forKey: "token")
    }
    
    static func getToken() -> String? {
        return defaults.value(forKey: "token") as? String 
    }

    static func setSpheres(value: [SelectedSphere]?) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        defaults.set(encodedData, forKey: "spheres")
        defaults.synchronize()
    }

    static func getSpheres() -> [SelectedSphere]? {
        let decoded  = defaults.data(forKey: "spheres")
        if decoded != nil{
            let decodedCount = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? [SelectedSphere]
            return decodedCount
        } else {
            return nil
        }
    }
    
    static func setStartDate(_ value: Date) {
        defaults.setValue(value, forKey: "startDate")
    }
    
    static func getStartDate() -> Date? {
        return defaults.value(forKey: "startDate") as? Date
    }
    
    static func setEmail(_ value: String) {
        defaults.setValue(value, forKey: "email")
    }
    
    static func getEmail() -> String? {
        return defaults.value(forKey: "email") as? String
    }
    
    static func setIsPremium(_ value: Bool) {
        defaults.setValue(value, forKey: "isPremium")
    }
    
    static func getIsPremium() -> Bool{
    if let value = defaults.value(forKey: "isPremium"){
        if value as! Int == 1{
            return true
        } else {
            return false
        }
    }
    return false
    }
    
    static func setPremiumType(_ value: String) {
        defaults.setValue(value, forKey: "premiumType")
    }
    
    static func getPremiumType() -> String? {
        return defaults.value(forKey: "premiumType") as? String
    }
    
    static func setNotifications(_ value: Bool){
        defaults.setValue(value, forKey: "notifications")
    }
    
    static func getNotifications() -> Bool{
        if let value = defaults.value(forKey: "notifications"){
            if value as! Int == 1{
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    static func setFCMToken(_ value: String) {
        defaults.setValue(value, forKey: "FCMToken")
    }
    
    static func getFCMToken() -> String? {
        return defaults.value(forKey: "FCMToken") as? String
    }
    
    static func clear(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
