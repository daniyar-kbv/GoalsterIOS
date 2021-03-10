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
    case light = "Gilroy-Light"
    case regular = "Gilroy-Regular"
    case medium = "Gilroy-Medium"
    case semiBold = "Gilroy-Semibold"
    case bold = "Gilroy-Bold"
    case black = "Gilroy-Black"
}

enum SecondaryFontStyles: String {
    case black = "Gotham-Black"
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
    
    var localeIdentifier: String {
        switch self {
        case .ru:
            return "ru_RU"
        case .en:
            return "en_US_POSIX"
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
    
    var icon: UIImage {
        switch self {
        case .career:
            return UIImage(named: "CareerBusiness")!
        default:
            return UIImage(named: self.rawValue)!
        }
    }
    
    static func findByName(name: String) -> Sphere {
        var returning: Sphere = .addOwnOption
        Sphere.allCases.forEach({
            if $0.rawValue.en == name || $0.rawValue.ru == name {
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
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
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

enum ProfileCellType: CaseIterable {
    case personalInfo
    case observe
    case observers
    case following
    case language
    case premium
    case notifications
    case help
    case about
    case rateApp
    
    var title: String {
        switch self {
        case .personalInfo:
            return "Personal info".localized
        case .observe:
            return "Observe".localized
        case .observers:
            return "My observers".localized
        case .following:
            return "Following".localized
        case .language:
            return "Change app's language".localized
        case .premium:
            return "Premium subscription".localized
        case .notifications:
            return "Notifications".localized
        case .help:
            return "Help".localized
        case .about:
            return "About app".localized
        case .rateApp:
            return "Rate app".localized
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
        case .premium:
            return ModuleUserDefaults.getIsPremium() ?
                "\("Valid through".localized) \(ModuleUserDefaults.getPremiumEndDate()?.toDate()?.format(format: "dd.MM.yyyy") ?? "")" :
                "Not purchased".localized
        default:
            return nil
        }
    }
}

enum NotificationType: Int {
    case threeDays = 1
    case beforeEnd = 2
    case end = 3
    case comment = 4
    
    var title: String?{
        switch self {
        case .threeDays:
            return "Three days notification title".localized
        case .beforeEnd:
            return "Before end notification title".localized
        case .end:
            return "End notification title".localized
        case .comment:
            return "New comment".localized
        }
    }
    
    var message: String?{
        switch self {
        case .threeDays:
            return "Three days notification message".localized
        case .beforeEnd:
            return "Before end notification message".localized
        case .end:
            return "End notification message".localized
        case .comment:
            return ""
        }
    }
}

enum ProductType: String {
    case oneMonth = "com.goalsterapp.onemonth"
    case threeMonth = "com.goalsterapp.threemonth"
    case sixMonth = "com.goalsterapp.sixmonth"
    case oneYear = "com.goalsterapp.oneyear"
    
    var timeAmount: Int {
        switch self {
        case .oneMonth, .oneYear:
            return 1
        case .threeMonth:
            return 3
        case .sixMonth:
            return 6
        }
    }
    
    var timeUnit: TimeUnit {
        switch self {
        case .oneMonth, .threeMonth, .sixMonth:
            return .month
        case .oneYear:
            return .year
        }
    }
}

enum TimeUnit: Int {
    case month = 1
    case year = 2
}

enum DeepLinkType: Int {
    case auth = 1
    case premium = 2
}

enum SegmentType: CaseIterable {
    case emotions
    case visualizations
    case following
    case recommendations
    
    var name: String {
        switch self {
        case .emotions:
            return "Emotions".localized
        case .visualizations:
            return "Visualizations".localized
        case .following:
            return "Following".localized
        case .recommendations:
            return "Reccondations".localized
        }
    }
    
    var viewController: SegmentVc {
        switch self {
        case .emotions:
            return EmotionsMainViewController(id: self.name)
        case .visualizations:
            return VisualizationsMainViewcontroller(id: self.name)
        case .following:
            return FeedViewController(type: .following, id: self.name)
        case .recommendations:
            return FeedViewController(type: .recommendations, id: self.name)
        }
    }
}
