//
//  API.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit

class API: NSObject {
    
    typealias NetworkResult = (Any?, RequestError) -> Void
    
    static let shared = API()
    fileprivate let defaultSession: URLSession
    fileprivate let baseUrl: String = ""
    
    private override init() {
        let configuration = URLSessionConfiguration.default
        self.defaultSession = URLSession(configuration: configuration)
    }
    
}


// MARK: - Enums
extension API {
    enum Endpoints {
        case login(mail: String, password: String)
        
        var method: String {
            switch self {
            case .login: return RequestType.post.rawValue
            }
        }
        
        var path: String {
            switch self {
            case .login: return "POST"
            }
        }
        
        var parameters: [String: Any] {
            var parameters = [String: Any]()
            
            switch self {
            case .login(let mail, let password) :
                parameters["email"] = mail
                parameters["password"] = password
            }
            
            return parameters
        }
    }
    
    enum RequestError: Error {
        case invalidUrl
        case clientSide
        case serverSide
        case parse
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
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONSerialization.data(withJSONObject: endpoint.parameters, options: .init(rawValue: 0))
        self.defaultSession.dataTask(with: request) { data, response, error in
            guard error != nil else {
                completion(nil, .clientSide)
                return
            }
            
            guard (response as! HTTPURLResponse).statusCode == 200 else {
                completion(nil, .serverSide)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options:[]) else {
                completion(nil, .parse)
                return
            }
            
            completion(json, nil)
            
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






