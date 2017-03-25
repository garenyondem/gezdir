//
//  Event+Services.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import Foundation
import MapKit

extension Event {
    typealias EventListResult = ([Event]?, API.RequestError?) -> Void
    typealias CreateEventResult = (Event?, API.RequestError?) -> Void
    typealias AttendEventResult = (API.RequestError?) -> Void
    
    static func events(around location: CLLocationCoordinate2D, for groupType: GroupType, completion: @escaping EventListResult) {
        
        API.shared.request(endpoint: .events(around: location, groupType: groupType)) { (jsonObject, error) in
            print(jsonObject)
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
    
    func create(completion: @escaping CreateEventResult) {
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
    
    func attend(completion: @escaping AttendEventResult) {
        API.shared.request(endpoint: .attendEventBy(id: self.eventId)) { (_, error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
}
