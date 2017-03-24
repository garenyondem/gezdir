//
//  API.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit
import MapKit

class API: NSObject {
    
    typealias NetworkResult = (Any?, RequestError?) -> Void
    
    static let shared = API()
    fileprivate let defaultSession: URLSession
    fileprivate let baseUrl: String = "http://gezdir.com"
    
    private override init() {
        let configuration = URLSessionConfiguration.default
        self.defaultSession = URLSession(configuration: configuration)
    }
    
}


// MARK: - Enums
extension API {
    enum Endpoints {
        case login(mail: String, password: String)
        case events(around: CLLocationCoordinate2D, userType: Int)
        
        var method: String {
            switch self {
            case .login: return RequestType.post.rawValue
            case .events: return RequestType.get.rawValue
            }
        }
        
        var path: String {
            switch self {
            case .login: return "/user/login"
            case .events: return "/event"
            }
        }
        
        var parameters: [String: Any] {
            var parameters = [String: Any]()
            
            switch self {
            case .login(let mail, let password) :
                parameters["email"] = mail
                parameters["password"] = password
            case .events(let location, let userType):
                // TODO:
                parameters[""] = ""
                parameters[""] = ""
                parameters[""] = ""
            }
            
            return parameters
        }
        
        var needsAuthorization: Bool {
            switch self {
            case .login: return false
            case .events: return true
            }
        }
    }
    
    enum RequestError: Error {
        case invalidUrl
        case clientSide
        case serverSide(message: String)
        case parse
        case wrongCredentials
    }
    
    enum RequestType: String {
        case get = "GET"
        case post = "POST"
    }
}

// MARK: - Service Funtions
extension API {
    func request(endpoint: Endpoints, completion: @escaping NetworkResult) {
        guard let url = self.url(for: endpoint) else {
            completion(nil, .invalidUrl)
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.httpMethod = endpoint.method
        
        if  endpoint.needsAuthorization,
            let token = User.current?.token {
            //request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue(token, forHTTPHeaderField: "Token")
        }
        request.addValue("Tokenasdadasdas", forHTTPHeaderField: "Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONSerialization.data(withJSONObject: endpoint.parameters, options: .init(rawValue: 0))
        self.defaultSession.dataTask(with: request) { data, response, error in
            guard error == nil else { // Client Error
                completion(nil, .clientSide)
                return
            }
            
            guard (response as! HTTPURLResponse).statusCode == 200 else {
                if  let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: []),
                    let json = jsonObject as? [String: Any],
                    let message = json["errorMessage"] as? String {
                    completion(nil, .serverSide(message: NSLocalizedString(message, comment: "")))
                }
                else {
                    completion(nil, .serverSide(message: NSLocalizedString("an_error_occured", comment: "")))
                }
                return
            }
            
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data!, options:[]) else {
                completion(nil, .parse)
                return
            }
            
            completion(jsonObject, nil)
            
        }.resume()
    }
    
    
}

// MARK: - Helpers
extension API {
    fileprivate func url(for endpoint: Endpoints) -> URL? {
        var urlComponent = URLComponents(string: self.baseUrl)
        urlComponent?.path = endpoint.path
        return urlComponent?.url
    }
}


