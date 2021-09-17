//
//  EndPoint.swift
//  Samokat
//
//  Created by Daniyar on 7/14/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import Alamofire

enum APIPoint {
    case connect
    case verify(email: String)
    case auth(email: String)
    case chooseSpheres(spheres: [String: Any])
    case updateSpheres(descriptions: [String])
    case goals(date: String?, observation: Int?)
    case calendar(observation: Int?)
    case searchObserver(q: String)
    case addGoal(name: String, date: String, time: TimeOfTheDay, isShared: Bool, observer: Int? = nil, sphere: Int, isPublic: Bool)
    case todayGoals
    case doneGoal(id: Int)
    case getEmotions
    case addEmtions(answers: [[String: Any]])
    case getVisualizations
    case addVisualization(parameters: [String: Any])
    case deleteVisualization(id: Int)
    case getObserved
    case getObservers
    case acceptObservation(id: Int, isConfirmed: Bool)
    case deleteObservation(id: Int)
    case changeLanguage(language: Language)
    case changeNotifications(isOn: Bool)
    case getNotifications
    case help(text: String)
    case premium(identifier: String, date: String, productType: ProductType)
    case results
    case temp_auth(email: String)
    case test_time
    case updateProfile(parameters: [String: Any])
    case sendCode(email: String)
    case verifyOTP(email: String, code: String)
    case register(parameters: [String: Any])
    case comments(goalId: Int)
    case leaveComment(goalId: Int, text: String)
    case updateGoal(goalId: Int, name: String, date: String, time: TimeOfTheDay, isShared: Bool, observer: Int? = nil, sphere: Int, isPublic: Bool)
    case feed(type: String, page: Int)
    case react(userId: Int, reactionId: Int)
    case feedDetail(userId: Int)
    case follow(userId: Int)
    case following
}

extension APIPoint: EndPointType {
    var path: String {
        switch self {
        case .connect:
            return "/users/users/connect_v2/"
        case .verify:
            return "/users/users/send_activation_email_v4/"
        case .auth(let email):
            return "/users/users/\(email)/verify_email/"
        case .chooseSpheres:
            return "/main/spheres/choose_spheres/"
        case .updateSpheres:
            return "/main/spheres/my_spheres/"
        case .goals:
            return "/main/goals/"
        case .calendar:
            return "/main/goals/calendar/"
        case .searchObserver:
            return "/users/users/search/"
        case .addGoal:
            return "/main/goals/add_v5/"
        case .todayGoals:
            return "/main/goals/today/"
        case .doneGoal(let id):
            return "/main/goals/\(id)/done/"
        case .getEmotions:
            return "/main/emotions/"
        case .addEmtions:
            return "/main/emotions/add/"
        case .getVisualizations, .addVisualization:
            return "/main/visualizations/"
        case .deleteVisualization(let id):
            return "/main/visualizations/\(id)/"
        case .getObserved:
            return "/main/observations/observed/"
        case .getObservers:
            return "/main/observations/observers/"
        case .acceptObservation(let id, _):
            return "/main/observations/\(id)/accept/"
        case .deleteObservation(let id):
            return "/main/observations/\(id)/remove/"
        case .changeLanguage:
            return "/users/users/change_language/"
        case .changeNotifications, .getNotifications:
            return "/users/users/notifications/"
        case .help:
            return "/main/help/"
        case .premium:
            return "/users/users/premium_v2/"
        case .results:
            return "/users/users/results/"
        case .temp_auth:
            return "users/users/temp_auth/"
        case .test_time:
            return "/main/spheres/test/"
        case .updateProfile:
            return "/users/users/update_profile/"
        case .sendCode:
            return "/users/users/login_resend_otp/"
        case .verifyOTP:
            return "/users/users/verify_otp/"
        case .register:
            return "/users/users/register/"
        case .comments, .leaveComment:
            return "/main/comments/"
        case .updateGoal(let goalId, _, _, _, _, _, _, _):
            return "/main/goals/\(goalId)/"
        case .feed:
            return "users/feed_v2/"
        case .react(let userId, _):
            return "/users/feed_v2/\(userId)/react/"
        case .feedDetail(let userId):
            return "users/feed_v2/\(userId)/"
        case .follow(let userId):
            return "/users/feed_v2/\(userId)/follow/"
        case .following:
            return "/users/users/following/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .connect, .verify, .chooseSpheres, .addGoal, .doneGoal, .addEmtions, .addVisualization, .acceptObservation, .deleteObservation, .changeNotifications, .changeLanguage, .help, .premium, .temp_auth, .test_time, .sendCode, .verifyOTP, .register, .leaveComment, .react, .follow:
            return .post
        case .updateSpheres, .updateProfile, .updateGoal:
            return .put
        case .deleteVisualization:
            return .delete
        default:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .connect:
            return [
                "fcm_token": ModuleUserDefaults.getFCMToken() ?? ""
            ]
        case .verify(let email):
            return [
                "email": email
            ]
        case .chooseSpheres(let spheres):
            return spheres
        case .updateSpheres(let descriptions):
            return [
                "descriptions": descriptions
            ]
        case .goals(let date, let observation):
            var parameters = Parameters()
            if let date = date {
                parameters["date"] = date
            }
            if let observation = observation {
                parameters["observation"] = observation
            }
            return parameters
        case .calendar(let observation):
            var parameters = Parameters()
            if let observation = observation {
                parameters["observation"] = observation
            }
            return parameters
        case .searchObserver(let q):
            return [
                "q": q
            ]
        case .addGoal(let name, let date, let time, let isShared, let observer, let sphere, let isPublic):
            return [
                "name": name,
                "date": date,
                "time": time.rawValue,
                "is_shared": isShared,
                "observer": observer,
                "sphere": sphere,
                "is_public": isPublic
            ]
        case .addEmtions(let answers):
            return [
                "answers": answers
            ]
        case .addVisualization(let parameters), .updateProfile(let parameters), .register(let parameters):
            return parameters
        case .acceptObservation(_, let isConfirmed):
            return [
                "is_confirmed": isConfirmed
            ]
        case .changeLanguage(let language):
            return [
                "language": language.number
            ]
        case .changeNotifications(let isOn):
            return [
                "enable": isOn
            ]
        case .help(let text):
            return [
                "text": text
            ]
        case .premium(let identifier, let date, let productType):
            let parameters: Parameters = [
                "identifier": identifier,
                "date": date,
                "product_id": productType.rawValue,
                "time_amount": productType.timeAmount,
                "time_unit": productType.timeUnit.rawValue
            ]
            return parameters
        case .temp_auth(let email), .sendCode(let email):
            return [
                "email": email
            ]
        case .verifyOTP(let email, let code):
            return [
                "email": email,
                "otp": code
            ]
        case .comments(let goalId):
            return [
                "goal": goalId
            ]
        case .leaveComment(let goalId, let text):
            return [
                "goal": goalId,
                "text": text
            ]
        case .updateGoal( _, let name, let date, let time, let isShared, let observer, let sphere, let isPublic):
            return [
                "name": name,
                "date": date,
                "time": time.rawValue,
                "is_shared": isShared,
                "observer": observer,
                "sphere": sphere,
                "is_public": isPublic
            ]
        case .feed(let type, let page):
            return [
                "type": type,
                "page": page
            ]
        case .react( _, let reactionId):
            return [
                "reaction": reactionId
            ]
        default:
            return nil
        }
    }
    
    var encoding: Encoder.Encoding {
        switch self {
        case .goals, .calendar, .searchObserver, .comments, .feed:
            return .urlEncoding
        default:
            return .jsonEncoding
        }
    }
    
    var additionalHeaders: HTTPHeaders? {
        switch self {
        default:
            return nil
        }
    }
    
    var baseURL: URL {
        return URL(string: "\(APIPoint.startURL)/api")!
    }
    
    var header: HTTPHeaders? {
        switch self {
        case .auth, .verify, .temp_auth, .test_time, .sendCode, .verifyOTP, .register:
            return [
                "Accept-Language": ModuleUserDefaults.getLanguage() == .en ? "en-us" : "ru-ru",
                "Timezone": TimeZone.current.identifier,
                "FCM": ModuleUserDefaults.getFCMToken() ?? ""
            ]
        case .feed:
            var headers: HTTPHeaders = [
                "Accept-Language": ModuleUserDefaults.getLanguage() == .en ? "en-us" : "ru-ru",
                "Timezone": TimeZone.current.identifier,
                "FCM": ModuleUserDefaults.getFCMToken() ?? ""
            ]
            if let token = ModuleUserDefaults.getToken() {
                headers["Authorization"] = "JWT \(token)"
            }
            return headers
        default:
            return [
                "Accept-Language": ModuleUserDefaults.getLanguage() == .en ? "en-us" : "ru-ru",
                "Authorization": "JWT \(ModuleUserDefaults.getToken() ?? "")",
                "Timezone": TimeZone.current.identifier,
                "FCM": ModuleUserDefaults.getFCMToken() ?? ""
            ]
        }
    }
    
    static var startURL = "http://161.35.198.233:8000"
//    static var startURL = "http://192.168.0.119:8990"
//    static var startURL = "https://api.24goalsapp.com"
}
