//
//  APIManager.swift
//  Samokat
//
//  Created by Daniyar on 7/14/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

struct APIManager {
    static let shared = APIManager()
    let router = MyRouter<APIPoint>()
    
    func connect(completion:@escaping(_ error:String?,_ module: AuthResponse?)->()) {
        router.request(.connect, returning: AuthResponse?.self) { error, response in
            completion(error, response as? AuthResponse)
        }
    }
    
    func verify(email: String, completion:@escaping(_ error:String?,_ module: AuthResponse?)->()) {
        router.request(.verify(email: email), returning: AuthResponse?.self) { error, response in
            completion(error, response as? AuthResponse)
        }
    }
    
    func auth(email: String, completion:@escaping(_ error:String?,_ module: AuthResponse?)->()) {
        router.request(.auth(email: email), returning: AuthResponse?.self) { error, response in
            completion(error, response as? AuthResponse)
        }
    }
    
    func chooseSpheres(spheres: [String: Any], completion:@escaping(_ error:String?,_ module: ChooseSpheresResponse?)->()) {
        router.request(.chooseSpheres(spheres: spheres), returning: ChooseSpheresResponse?.self) { error, response in
            completion(error, response as? ChooseSpheresResponse)
        }
    }
    
    func updateSpheres(descriptions: [String], completion:@escaping(_ error:String?,_ module: ChooseSpheresResponse?)->()) {
        router.request(.updateSpheres(descriptions: descriptions), returning: ChooseSpheresResponse?.self) { error, response in
            completion(error, response as? ChooseSpheresResponse)
        }
    }
    
    func getGoals(date: String?, observation: Int?, completion:@escaping(_ error:String?,_ module: GoalsResponse?)->()) {
        router.request(.goals(date: date, observation: observation), returning: GoalsResponse?.self) { error, response in
            completion(error, response as? GoalsResponse)
        }
    }
    
    func getCalendar(observation: Int? = nil, completion:@escaping(_ error:String?,_ module: CalendarResponse?)->()) {
        router.request(.calendar(observation: observation), returning: CalendarResponse?.self) { error, response in
            completion(error, response as? CalendarResponse)
        }
    }
    
    func searchObserver(q: String, completion:@escaping(_ error:String?,_ module: SearchResponse?)->()) {
        router.request(.searchObserver(q: q), returning: SearchResponse?.self) { error, response in
            completion(error, response as? SearchResponse)
        }
    }
    
    func addGoal(name: String, date: String, time: TimeOfTheDay, isShared: Bool, observer: Int? = nil, sphere: Int, isPublic: Bool, completion:@escaping(_ error:String?,_ module: Goal?)->()) {
        router.request(.addGoal(name: name, date: date, time: time, isShared: isShared, observer: observer, sphere: sphere, isPublic: isPublic), returning: Goal?.self) { error, response in
            completion(error, response as? Goal)
        }
    }
    
    func todayGoals(completion:@escaping(_ error:String?,_ module: TodayGoalsResponse?)->()) {
        router.request(.todayGoals, returning: TodayGoalsResponse?.self) { error, response in
            completion(error, response as? TodayGoalsResponse)
        }
    }
    
    func doneGoal(id: Int, completion:@escaping(_ error:String?,_ module: Bool?)->()) {
        router.request(.doneGoal(id: id), returning: Bool?.self, boolResult: true) { error, response in
            completion(error, response as? Bool)
        }
    }
    
    func getEmotions(completion:@escaping(_ error:String?,_ module: EmotionsResponse?)->()) {
        router.request(.getEmotions, returning: EmotionsResponse?.self) { error, response in
            completion(error, response as? EmotionsResponse)
        }
    }
    
    func addEmotions(answers: [[String: Any]], completion:@escaping(_ error:String?,_ module: EmotionsResponse?)->()) {
        router.request(.addEmtions(answers: answers), returning: EmotionsResponse?.self) { error, response in
            completion(error, response as? EmotionsResponse)
        }
    }
    
    func getVisualizations(completion:@escaping(_ error:String?,_ module: VisualizationsResponse?)->()) {
        router.request(.getVisualizations, returning: VisualizationsResponse?.self) { error, response in
            completion(error, response as? VisualizationsResponse)
        }
    }
    
    func addVisualization(parameters: [String: Any], completion:@escaping(_ error:String?,_ module: SphereVisualization?)->()) {
        router.upload(.addVisualization(parameters: parameters), returning: SphereVisualization?.self) { error, response in
            completion(error, response as? SphereVisualization)
        }
    }
    
    func deleteVisualization(id: Int, completion: @escaping(_ error:String?,_ module: Bool?)->()) {
        router.request(.deleteVisualization(id: id), returning: Bool?.self, boolResult: true) { error, response in
            completion(error, response as? Bool)
        }
    }
    
    func getObserved(completion:@escaping(_ error:String?,_ module: ObservedResponse?)->()) {
        router.request(.getObserved, returning: ObservedResponse?.self) { error, response in
            completion(error, response as? ObservedResponse)
        }
    }
    
    func getObservers(completion:@escaping(_ error:String?,_ module: ObserversResponse?)->()) {
        router.request(.getObservers, returning: ObserversResponse?.self) { error, response in
            completion(error, response as? ObserversResponse)
        }
    }
    
    func acceptObservation(id: Int, isConfirmed: Bool, completion:@escaping(_ error:String?,_ module: Bool?)->()) {
        router.request(.acceptObservation(id: id, isConfirmed: isConfirmed), returning: Bool?.self, boolResult: true) { error, response in
            completion(error, response as? Bool)
        }
    }
    
    func deleteObservation(id: Int, completion:@escaping(_ error:String?,_ module: Bool?)->()) {
        router.request(.deleteObservation(id: id), returning: Bool?.self, boolResult: true) { error, response in
            completion(error, response as? Bool)
        }
    }
    
    func changeLanguage(language: Language, completion:@escaping(_ error:String?,_ module: Bool?)->()) {
        router.request(.changeLanguage(language: language), returning: Bool?.self, boolResult: true) { error, response in
            completion(error, response as? Bool)
        }
    }
    
    func changeNotifications(isOn: Bool, completion:@escaping(_ error:String?,_ module: Bool?)->()) {
        router.request(.changeNotifications(isOn: isOn), returning: Bool?.self, boolResult: true) { error, response in
            completion(error, response as? Bool)
        }
    }
    
    func getNotifications(completion:@escaping(_ error:String?,_ module: NotificationsResponse?)->()) {
        router.request(.getNotifications, returning: NotificationsResponse?.self) { error, response in
            completion(error, response as? NotificationsResponse)
        }
    }
    
    func help(text: String, completion:@escaping(_ error:String?,_ module: Bool?)->()) {
        router.request(.help(text: text), returning: Bool?.self, boolResult: true) { error, response in
            completion(error, response as? Bool)
        }
    }
    
    func premium(identifier: String, date: String, productType: ProductType, completion:@escaping(_ error:String?,_ module: Bool?)->()) {
        router.request(.premium(identifier: identifier, date: date, productType: productType), returning: Bool?.self, boolResult: true) { error, response in
            completion(error, response as? Bool)
        }
    }
    
    func results(completion:@escaping(_ error:String?,_ module: ResultsResponse?)->()) {
        router.request(.results, returning: ResultsResponse?.self) { error, response in
            completion(error, response as? ResultsResponse)
        }
    }
    
    func tempAuth(email: String, completion:@escaping(_ error:String?,_ module: AuthResponse?)->()) {
        router.request(.temp_auth(email: email), returning: AuthResponse?.self) { error, response in
            completion(error, response as? AuthResponse)
        }
    }
    
    func testTime(completion:@escaping(_ error:String?,_ module: GeneralResponse?)->()) {
        router.request(.test_time, returning: GeneralResponse?.self) { error, response in
            completion(error, response as? GeneralResponse)
        }
    }
    
    func updateProfile(parameters: [String: Any], completion:@escaping(_ error: String?, _ module: UpdateProfileResponse?)->()) {
        router.upload(.updateProfile(parameters: parameters), returning: UpdateProfileResponse?.self) { error, response in
            completion(error, response as? UpdateProfileResponse)
        }
    }
    
    func sendCode(email: String, completion:@escaping(_ error:String?,_ module: SendCodeResponse?)->()) {
        router.request(.sendCode(email: email), returning: SendCodeResponse?.self) { error, response in
            completion(error, response as? SendCodeResponse)
        }
    }
    
    func verifyOTP(email: String, code: String, completion:@escaping(_ error:String?,_ module: AuthResponse?)->()) {
        router.request(.verifyOTP(email: email, code: code), returning: AuthResponse?.self) { error, response in
            completion(error, response as? AuthResponse)
        }
    }
    
    func register(parameters: [String: Any], completion:@escaping(_ error: String?, _ module: RegisterResponse?)->()) {
        router.upload(.register(parameters: parameters), returning: RegisterResponse?.self) { error, response in
            completion(error, response as? RegisterResponse)
        }
    }
    
    func comments(goalId: Int, completion:@escaping(_ error: String?, _ module: [Comment]?)->()) {
        router.request(.comments(goalId: goalId), returning: [Comment]?.self) { error, response in
            completion(error, response as? [Comment])
        }
    }
    
    func leaveComment(goalId: Int, text: String, completion:@escaping(_ error: String?, _ module: CreateCommentResponse?)->()) {
        router.request(.leaveComment(goalId: goalId, text: text), returning: CreateCommentResponse?.self) { error, response in
            completion(error, response as? CreateCommentResponse)
        }
    }
    
    func updateGoal(goalId: Int, name: String, date: String, time: TimeOfTheDay, isShared: Bool, observer: Int? = nil, sphere: Int, isPublic: Bool, completion: @escaping(_ error: String?,_ module: Goal?)->()) {
        router.request(.updateGoal(goalId: goalId, name: name, date: date, time: time, isShared: isShared, observer: observer, sphere: sphere, isPublic: isPublic), returning: Goal?.self) { error, response in
            completion(error, response as? Goal)
        }
    }
    
    func feed(type: String, page: Int, completion: @escaping(_ error: String?,_ module: FeedResponse?)->()) {
        router.request(.feed(type: type, page: page), returning: FeedResponse?.self) { error, response in
            completion(error, response as? FeedResponse)
        }
    }
    
    func react(userId: Int, reactionId: Int, completion: @escaping(_ error: String?,_ module: Reaction?)->()) {
        router.request(.react(userId: userId, reactionId: reactionId), returning: Reaction?.self) { error, response in
            completion(error, response as? Reaction)
        }
    }
    
    func feedDetail(userId: Int, completion: @escaping(_ error: String?,_ module: FeedUserFull?)->()) {
        router.request(.feedDetail(userId: userId), returning: FeedUserFull?.self) { error, response in
            completion(error, response as? FeedUserFull)
        }
    }
    
    func follow(userId: Int, completion: @escaping(_ error: String?,_ module: FeedUserFull?)->()) {
        router.request(.follow(userId: userId), returning: FeedUserFull?.self) { error, response in
            completion(error, response as? FeedUserFull)
        }
    }
    
    func following(completion: @escaping(_ error: String?,_ module: [FeedUserFull]?)->()) {
        router.request(.following, returning: [FeedUserFull]?.self) { error, response in
            completion(error, response as? [FeedUserFull])
        }
    }
}
