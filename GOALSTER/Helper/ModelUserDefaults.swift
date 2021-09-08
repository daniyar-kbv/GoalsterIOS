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
    
    static func setSpheres(object: [SelectedSphere]) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: "spheres")
            defaults.synchronize()
        } catch {
        }
    }

    static func getSpheres() -> [SelectedSphere]? {
        guard let decoded = defaults.data(forKey: "spheres") else {
            return nil
        }
        do {
            let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? [SelectedSphere]
            return decoded
        } catch {
            print(error)
            return nil
        }
    }
    
    static func setTotalGoals(object: TotalGoals) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: "totalGoals")
            defaults.synchronize()
        } catch {
        }
    }

    static func getTotalGoals() -> TotalGoals? {
        guard let decoded = defaults.data(forKey: "totalGoals") else {
            return nil
        }
        do {
            let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? TotalGoals
            return decoded
        } catch {
            print(error)
            return nil
        }
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
    
    static func setPremiumEndDate(_ value: String?) {
        defaults.setValue(value, forKey: "PremiumEndDate")
    }
    
    static func getPremiumEndDate() -> String? {
        return defaults.value(forKey: "PremiumEndDate") as? String
    }
    
    static func setFCMToken(_ value: String) {
        defaults.setValue(value, forKey: "FCMToken")
    }
    
    static func getFCMToken() -> String? {
        return defaults.value(forKey: "FCMToken") as? String
    }
    
    static func setIsPurchaseProcessed(_ value: Bool){
        defaults.setValue(value, forKey: "isPurchaseProcessed")
    }
    
    static func getIsPurchaseProcessed() -> Bool{
        guard let value = defaults.value(forKey: "isPurchaseProcessed") as? Int else { return true }
        return value == 1
    }
    
    static func setLastPurchase(object: PremiumPurchase) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: "lastPurchase")
            defaults.synchronize()
        } catch {
        }
    }

    static func getLastPurchase() -> PremiumPurchase? {
        guard let decoded = defaults.data(forKey: "lastPurchase") else {
            return nil
        }
        do {
            let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? PremiumPurchase
            return decoded
        } catch {
            print(error)
            return nil
        }
    }
    
    static func setProfile(object: Profile) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: "profile")
            defaults.synchronize()
        } catch {
        }
    }

    static func getProfile() -> Profile? {
        guard let decoded = defaults.data(forKey: "profile") else {
            return nil
        }
        do {
            let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? Profile
            return decoded
        } catch {
            print(error)
            return nil
        }
    }
    
    static func setGoalsStatus(object: GoalsStatus?) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: object as Any, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: "GoalsStatus")
            defaults.synchronize()
        } catch {
            print(error)
        }
    }

    static func getGoalsStatus() -> GoalsStatus? {
        guard let decoded = defaults.data(forKey: "GoalsStatus") else {
            return nil
        }
        do {
            let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? GoalsStatus
            return decoded
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func setLocalCalendar(object: [LocalCalendarItem]?) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: object as Any, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: "LocalCalendarItem")
            defaults.synchronize()
        } catch {
            print(error)
        }
    }

    static func getLocalCalendar() -> [LocalCalendarItem]? {
        guard let decoded = defaults.data(forKey: "LocalCalendarItem") else {
            return nil
        }
        do {
            let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? [LocalCalendarItem]
            return decoded
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func setEmotions(object: [EmotionAnswer]?) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: object as Any, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: "EmotionAnswer")
            defaults.synchronize()
        } catch {
            print(error)
        }
    }

    static func getEmotions() -> [EmotionAnswer]? {
        guard let decoded = defaults.data(forKey: "EmotionAnswer") else {
            return nil
        }
        do {
            let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? [EmotionAnswer]
            return decoded
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func setVisualizations(object: [SphereVisualization]?) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: object as Any, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: "SphereVisualization")
            defaults.synchronize()
        } catch {
            print(error)
        }
    }

    static func getVisualizations() -> [SphereVisualization]? {
        guard let decoded = defaults.data(forKey: "SphereVisualization") else {
            return nil
        }
        do {
            let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? [SphereVisualization]
            return decoded
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func setIsNotificationsEnabled(_ value: Bool){
        defaults.setValue(value, forKey: "IsNotificationsEnabled")
    }
    
    static func getIsNotificationsEnabled() -> Bool {
        guard let value = defaults.value(forKey: "IsNotificationsEnabled") as? Int else { return false }
        return value == 1
    }
    
    static func setIsCleaned(_ value: Bool) {
        defaults.setValue(value, forKey: "isCleaned")
    }
    
    static func getIsCleaned() -> Bool {
        guard let value = defaults.value(forKey: "isCleaned") as? Int else { return false }
        return value == 1
    }
    
    static func clear(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
