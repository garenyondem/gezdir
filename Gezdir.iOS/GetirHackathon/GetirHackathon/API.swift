//
//  API.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

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
        case login(mail: String, password: String, language: String)
        case events(around: CLLocationCoordinate2D)
        case event(id: String)
        case tickets(around: CLLocationCoordinate2D)
        case createEvent(event: Event)
        case createTicket(ticket: Event)
        case eventTypes
        case attendEventBy(id: String)
        case acceptTicket(id: String)
        
        var method: String {
            switch self {
            case .login: return RequestType.post.rawValue
            case .events: return RequestType.get.rawValue
            case .event: return RequestType.get.rawValue
            case .createEvent: return RequestType.post.rawValue
            case .tickets: return RequestType.get.rawValue
            case .createTicket: return RequestType.post.rawValue
            case .eventTypes: return RequestType.get.rawValue
            case .attendEventBy: return RequestType.put.rawValue
            case .acceptTicket: return RequestType.get.rawValue
            }
        }
        
        var path: String {
            switch self {
            case .login: return "/user/login"
            case .events: return "/events"
            case .event: return "/events"
            case .createEvent: return "/events"
            case .tickets: return "/tickets"
            case .createTicket: return "/tickets"
            case .eventTypes: return "/eventTypes"
            case .attendEventBy(let id): return "/events/\(id)"
            case .acceptTicket(let id): return "/tickets/\(id)/accept"
            }
        }
        
        var parameters: [String: Any] {
            var parameters = [String: Any]()
            
            switch self {
            case .login(let mail, let password, let language):
                parameters["email"] = mail
                parameters["password"] = password
                parameters["language"] = language
            case .events:
                break
            case .tickets:
                break
            case .event:
                break
            case .createEvent(let event):
                parameters["name"] = event.name
                parameters["creationDate"] = event.creationDate.forApiFormatedString
                parameters["expirationDate"] = event.expirationDate.forApiFormatedString
                parameters["eventType"] = event.eventType.key
                parameters["coordinates"] = [event.location.longitude, event.location.latitude]
                parameters["quota"] = event.quota
            case .createTicket(let ticket):
                parameters["name"] = ticket.name
                parameters["creationDate"] = ticket.creationDate.forApiFormatedString
                parameters["expirationDate"] = ticket.expirationDate.forApiFormatedString
                parameters["eventType"] = ticket.eventType.key
                parameters["coordinates"] = [ticket.location.longitude, ticket.location.latitude]
                parameters["quota"] = ticket.quota
            case .eventTypes:
                break
            case .attendEventBy:
                break
            case .acceptTicket:
                break
            }
            
            return parameters
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .events(let around):
                let q1 = URLQueryItem(name: "latitude", value: String(around.latitude))
                let q2 = URLQueryItem(name: "longitude", value: String(around.longitude))
                return [q1, q2]
            case .event(let id):
                let q1 = URLQueryItem(name: "id", value: id)
                return [q1]
            case .tickets(let around):
                let q1 = URLQueryItem(name: "latitude", value: String(around.latitude))
                let q2 = URLQueryItem(name: "longitude", value: String(around.longitude))
                return [q1, q2]
            default: return nil
            }
            
            
        }
        
        var needsAuthorization: Bool {
            switch self {
            case .login: return false
            default: return true
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
        case put = "PUT"
    }
}

// MARK: - Service Funtions
extension API {
    func request(endpoint: Endpoints, completion: @escaping NetworkResult) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if !endpoint.parameters.isEmpty {
            request.httpBody = try? JSONSerialization.data(withJSONObject: endpoint.parameters, options: .init(rawValue: 0))
        }
        
        self.defaultSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard error == nil else { // Client Error
                completion(nil, .clientSide)
                return
            }
            
            guard (response as! HTTPURLResponse).statusCode == 200 else { // Server Side Check
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
        urlComponent?.queryItems = endpoint.queryItems
        return urlComponent?.url
    }
}


