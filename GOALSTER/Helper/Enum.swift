//
//  Enum.swift
//  Samokat
//
//  Created by Daniyar on 7/7/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

enum FontStyles: String {
    case mediumItalic = "MediumItalic"
    case medium = "Medium"
    case lightItalic = "LightItalic"
    case light = "Light"
    case bookItalic = "BookItalic"
    case book = "Book"
    case ultraItalic = "UltraItalic"
    case ultra = "Ultra"
    case boldItalic = "BoldItalic"
    case bold = "Bold"
    case extraLightItalic = "ExtraLightItalic"
    case extraLight = "ExtraLight"
}

enum Language: String {
    case ru
    case en
    
    var number: Int {
        switch self {
        case .ru:
            return 1
        case .en:
            return 2
        }
    }
}

enum GoalsViewState {
    case initial
    case notSelected
    case selected
}

enum Sphere: String, CaseIterable {
    case health = "Health"
    case education = "Education"
    case finances = "Finances"
    case relationships = "Relationships"
    case career = "Career/business"
    case spirituality = "Spirituality"
    case creation = "Creation";
    case personalGrowth = "Personal growth";
    case lifeBrightness = "Life brightness";
    case family = "Family";
    case encirclement = "Encirclement";
    case selfCultivation = "Self cultivation";
    case interests = "Interests";
    case intellect = "Intellect";
    case sport = "Sport";
    case leisure = "Leisure";
    case income = "Income";
    case recreation = "Recreation";
    case hobby = "Hobby";
    case travel = "Travel";
    case addOwnOption = "Add own option";
    
    var name: String {
        return self.rawValue.localized
    }
    
    var icon_inactive: UIImageView {
        if self == .career{
            return UIImageView(image: UIImage(named: "CareerBusiness"))
        }
        return UIImageView(image: UIImage(named: self.rawValue))
    }
    
    var icon_active: UIImageView {
        var view = UIImageView(image: UIImage(named: self.rawValue)?.withRenderingMode(.alwaysTemplate))
        if self == .career{
            view = UIImageView(image: UIImage(named: "CareerBusiness")?.withRenderingMode(.alwaysTemplate))
        }
        view.tintColor = .customActivePurple
        return view
    }
    
    static func findByName(name: String) -> Sphere {
        var returning: Sphere = .addOwnOption
        Sphere.allCases.forEach({
            if $0.rawValue == name || $0.name == name {
                returning = $0
            }
        })
        return returning
    }
}

enum CalendarViewState {
    case notSelected
    case noGoals
    case goals
}

enum DayOfWeek: Int {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    var toStr: String {
        switch self {
        case .monday:
            return "Mo".localized
        case .tuesday:
            return "Tu".localized
        case .wednesday:
            return "We".localized
        case .thursday:
            return "Th".localized
        case .friday:
            return "Fr".localized
        case .saturday:
            return "Sa".localized
        case .sunday:
            return "Su".localized
        }
    }
}

enum Month: String {
    case january = "01"
    case february = "02"
    case march = "03"
    case april = "04"
    case may = "05"
    case june = "06"
    case july = "07"
    case august = "08"
    case september = "09"
    case october = "10"
    case november = "11"
    case december = "12"
    
    var name: String {
        switch self {
        case .january:
            return "January".localized
        case .february:
            return "February".localized
        case .march:
            return "March".localized
        case .april:
            return "April".localized
        case .may:
            return "May".localized
        case .june:
            return "June".localized
        case .july:
            return "July".localized
        case .august:
            return "August".localized
        case .september:
            return "September".localized
        case .october:
            return "October".localized
        case .november:
            return "November".localized
        case .december:
            return "December".localized
        }
    }
}

enum SphereNumber: Int, Codable {
    case first = 1
    case second = 2
    case third = 3
}

enum TimeOfTheDay: Int, Codable {
    case morning = 1
    case day = 2
    case evening = 3
    
    var toStr: String {
        switch self {
        case .morning:
            return "Morning".localized
        case .day:
            return "Afternoon".localized
        case .evening:
            return "Evening".localized
        }
    }
    
    var icon: UIImage {
        switch self {
        case .morning:
            return UIImage(named: "morning")!
        case .day:
            return UIImage(named: "day")!
        case .evening:
            return UIImage(named: "evening")!
        }
    }
}

enum EmotionsState {
    case notAdded
    case added
}

enum VisualizationsState {
    case notAdded
    case added
}

enum ArrowDirection {
    case up
    case down
    case right
    case left
}

enum ProfileCellType {
    case observe
    case observers
    case language
    case spheres
    case premium
    case notifications
    case help
    case empty
    
    var arrowDirection: ArrowDirection {
        switch self {
        case .observe, .observers:
            return .right
        default:
            return .down
        }
    }
    
    var title: String {
        switch self {
        case .observe:
            return "Observe".localized
        case .observers:
            return "My observers".localized
        case .language:
            return "Change app's language".localized
        case .spheres:
            return "Chosen spheres".localized
        case .premium:
            return "Premium subscription".localized
        case .notifications:
            return "Notifications".localized
        case .help:
            return "Help".localized
        default:
            return ""
        }
    }
    
    var subtitle: String? {
        switch self {
        case .language:
            switch ModuleUserDefaults.getLanguage() {
            case .en:
                return "English"
            case .ru:
                return "Русский язык"
            }
        case .spheres:
            var spheres = ""
            if ModuleUserDefaults.getHasSpheres(){
                for (index, sphere) in (ModuleUserDefaults.getSpheres() ?? []).enumerated(){
                    if let name = sphere.sphere {
                        spheres.append(contentsOf: index != ModuleUserDefaults.getSpheres()?.count ? "\(name), " : name)
                    }
                }
            }
            return spheres
        case .premium:
            return ModuleUserDefaults.getIsPremium() ?? false ? "" : "Not purchased".localized
        default:
            return nil
        }
    }
}
