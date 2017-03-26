//
//  Event+Services.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import Foundation
import MapKit

// MARK: - Event related requests
extension Event {
    typealias EventListResult = ([Event]?, API.RequestError?) -> Void
    typealias CreateEventResult = (Event?, API.RequestError?) -> Void
    typealias AttendOrAcceptEventResult = (API.RequestError?) -> Void
    
    // MARK: - Public functions
    static func fetch(around location: CLLocationCoordinate2D, isTicket: Bool, completion: @escaping EventListResult) {
        
        if isTicket {
            Event.tickets(around: location, completion: { (eventList, error) in
                completion(eventList, error)
            })
        }
        else {
            Event.events(around: location, completion: { (eventList, error) in
                completion(eventList, error)
            })
        }
    }
    
    func createActivity(completion: @escaping CreateEventResult) {
        if self.isTicket {
            self.createTicket(completion: { (event, error) in
                completion(event, error)
            })
        }
        else {
            self.createEvent(completion: { (event, error) in
                completion(event, error)
            })
        }
    }
    
    func attendOrAccept(completion: @escaping AttendOrAcceptEventResult) {
        if self.isTicket {
            self.acceptTicket(completion: { (error) in
                completion(error)
            })
        }
        else {
            self.attend(completion: { (error) in
                completion(error)
            })
        }
    }
    
    func search(completion: @escaping EventListResult) {
        API.shared.request(endpoint: .search(event: self)) { (jsonObject, error) in
            var eventList = [Event]()
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let rootJson = jsonObject as? [Any] else {
                completion(nil, .parse)
                return
            }
            
            rootJson.forEach { eventData in
                if let eventDataJson = eventData as? [String: Any],
                    let event = Event(with: eventDataJson) {
                    eventList.append(event)
                }
            }
            
            completion(eventList, nil)
        }
    }
    
    // MARK: - Private functions
    private static func events(around location: CLLocationCoordinate2D, completion: @escaping EventListResult) {
        
        API.shared.request(endpoint: .events(around: location)) { (jsonObject, error) in
            var eventList = [Event]()
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let rootJson = jsonObject as? [Any] else {
                completion(nil, .parse)
                return
            }
            
            rootJson.forEach { eventData in
                if let eventDataJson = eventData as? [String: Any],
                    let event = Event(with: eventDataJson) {
                    eventList.append(event)
                }
            }
            
            completion(eventList, nil)
        }
        
    }
    
    private static func tickets(around location: CLLocationCoordinate2D, completion: @escaping EventListResult) {
        
        API.shared.request(endpoint: .tickets(around: location)) { (jsonObject, error) in
            var eventList = [Event]()
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let rootJson = jsonObject as? [Any] else {
                completion(nil, .parse)
                return
            }
            
            rootJson.forEach { eventData in
                if let eventDataJson = eventData as? [String: Any],
                    let event = Event(with: eventDataJson) {
                    eventList.append(event)
                }
            }
            
            completion(eventList, nil)
        }
        
    }
    
    private func createEvent(completion: @escaping CreateEventResult) {
        API.shared.request(endpoint: .createEvent(event: self)) { (jsonObject, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let rootJson = jsonObject as? [String: Any] else {
                completion(nil, .parse)
                return
            }
            
            if let event = Event(with: rootJson) {
                completion(event, nil)
            }
            else {
                completion(nil, .parse)
            }
        }
    }
    
    private func createTicket(completion: @escaping CreateEventResult) {
        API.shared.request(endpoint: .createTicket(ticket: self)) { (jsonObject, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let rootJson = jsonObject as? [String: Any] else {
                completion(nil, .parse)
                return
            }
            
            if let event = Event(with: rootJson) {
                completion(event, nil)
            }
            else {
                completion(nil, .parse)
            }
        }
    }
    
    private func attend(completion: @escaping AttendOrAcceptEventResult) {
        API.shared.request(endpoint: .attendEventBy(id: self.eventId)) { (_, error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    private func acceptTicket(completion: @escaping AttendOrAcceptEventResult) {
        API.shared.request(endpoint: .acceptTicket(id: self.eventId)) { (_, error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}
