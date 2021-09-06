//
//  APIManager.swift
//  Samokat
//
//  Created by Daniyar on 7/14/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request<T: Codable>(_ route: EndPoint, returning: T.Type, boolResult: Bool, completion: @escaping(_ error:String?,_ module: T?)->())
}

class MyRouter<EndPoint: EndPointType>: NetworkRouter{
    
    func request<T>(_ route: EndPoint, returning: T.Type, boolResult: Bool = false, completion: @escaping(_ error:String?,_ module: T?)->()) where T : Decodable, T : Encodable {
        let headers = { () -> HTTPHeaders? in
            var headers = route.header
            if let additionalHeaders = route.additionalHeaders{
                for header in additionalHeaders{
                    headers?.add(header)
                }
            }
            return headers
        }()
        AF.request(route.baseURL.appendingPathComponent(route.path), method: route.httpMethod, parameters: route.parameters, encoding: Encoder.getEncoding(route.encoding), headers: headers).responseData() { response in
            self.dataCompletion(response: response, boolResult: boolResult) { error, response in
                completion(error, response)
            }
        }
    }
    
    func upload<T>(_ route: EndPoint, returning: T.Type, boolResult: Bool = false, completion: @escaping(_ error:String?,_ module: T?)->()) where T : Decodable, T : Encodable {
        let headers = { () -> HTTPHeaders? in
            var headers = route.header
            if let additionalHeaders = route.additionalHeaders{
                for header in additionalHeaders{
                    headers?.add(header)
                }
            }
            return headers
        }()
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in route.parameters ?? [String: Any]() {
                if key == "image" || key == "avatar" || key == "profile.avatar"{
                    if let url = value as? URL{
                        multipartFormData.append(url, withName: key)
                    } else if let data = value as? Data {
                        multipartFormData.append(data, withName: key)
                    }
                } else if let data = "\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: route.baseURL.appendingPathComponent(route.path), usingThreshold: .zero, method: route.httpMethod, headers: headers, interceptor: nil, fileManager: .default).responseData(completionHandler: { response in
            self.dataCompletion(response: response, boolResult: boolResult) { error, response in
                completion(error, response)
            }
        })
    }

    func dataCompletion<T>(response: AFDataResponse<Data>, boolResult: Bool, completion: @escaping(_ error:String?,_ module: T?)->()) where T : Decodable, T : Encodable {
        guard let res = response.response else {
            completion(response.error?.localizedDescription, nil)
            return
        }
        let result = self.handleNetworkResponse(res)
        let statusCode = res.statusCode
        switch result {
        case .success:
            guard let responseData = response.data else {
                if response.response?.statusCode == 200 {
                    do{
                        let mBoolValue = true
                        let boolData = try JSONEncoder().encode(mBoolValue)
                        let apiResponse = try JSONDecoder().decode(T.self, from: boolData)
                        completion(nil, apiResponse)
                        return
                    } catch {
                        
                    }
                }
                completion(NetworkResponse.failed.localized, nil)
                return
            }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                print(jsonData)
                if statusCode == 404 {
                    completion(nil, nil)
                    return
                } else if ![200, 201].contains(statusCode) {
                    do {
                        let apiResponse = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                        completion(apiResponse.getFirst(), nil)
                        return
                    } catch {
                        completion(NetworkResponse.failed.localized, nil)
                        return
                    }
                } else if statusCode == 200 && boolResult{
                    do {
                        let mBoolValue = true
                        let boolData = try JSONEncoder().encode(mBoolValue)
                        let apiResponse = try JSONDecoder().decode(T.self, from: boolData)
                        completion(nil, apiResponse)
                        return
                    } catch {
                        completion(NetworkResponse.failed.localized, nil)
                        return
                    }
                }
                let apiResponse = try JSONDecoder().decode(T.self, from: responseData)
                completion(nil, apiResponse)
            }
            catch {
                completion(NetworkResponse.failed.localized,nil)
            }
        case .failure(let error):
            completion(error, nil)
        }
    }
    
    enum Result<String>{
        case success
        case failure(String)
    }

    enum NetworkResponse:String {
        case success
        case authenticationError = "Ты не авторизован"
        case badRequest = "Bad request"
        case outdated = "The url you requested is outdated."
        case failed = "Error uccured, please try egain"
        case noData = "Пустой ответ"
        case unableToDecode = "Мы не смогли лбр"
        case unauthorized
        
        var localized: String {
            return self.rawValue.localized
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...500: return .success
//        case 422: return .failure(NetworkResponse.badRequest.rawValue)
//        case 423...500: return .failure(NetworkResponse.authenticationError.rawValue)
//        case 500...599: return .failure(NetworkResponse.badRequest.rawValue)
//        case 600: return .failure(NetworkResponse.outdated.rawValue)
//        case 403: return .failure(NetworkResponse.unauthorized.rawValue)
        default: return .failure(NetworkResponse.failed.localized)
        }
    }
    
}
