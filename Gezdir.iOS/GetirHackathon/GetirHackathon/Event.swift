//
//  Event.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import Foundation
import MapKit

class Event {
    var eventId: String!
    var name: String!
    var creationDate: Date!
    var expirationDate: Date!
    var location: CLLocationCoordinate2D! {
        didSet {
            self.annotation = EventAnnotation(title: self.name, coordinate: self.location, subtitle: nil)
            self.annotation!.eventId = self.eventId
        }
    }
    var eventType: EventType!
    var quota: Int!
    var attendeeCount: Int = 0
    var isAttending = false
    var guideName: String!
    
    var isTicket = false
    var annotation: EventAnnotation?
    
    init() {}
    
    init(name: String = "", creationDate: Date, expirationDate: Date, location: CLLocationCoordinate2D, eventType: EventType, quota: Int) {
        self.name = name
        self.creationDate = creationDate
        self.expirationDate = expirationDate
        self.location = location
        self.eventType = eventType
        self.quota = quota
    }
    
    init?(with json: [String: Any]) {
        print(json)
        guard
            let eventId = json["_id"] as? String,
            let name = json["name"] as? String,
            let creationDateString = json["creationDate"] as? String,
            let expirationDate = json["expirationDate"] as? String,
            let locationJson = json["location"] as? [String: Any],
            let eventTypeJson = json["eventType"] as? [String: Any],
            let quota = json["quota"] as? Int
            else { return nil }
       
        if let attendees = json["attendees"] as? [Any],
            let attending = json["attending"] as? Bool,
            let guideName = json["guideName"] as? String {
            self.attendeeCount = attendees.count
            self.isAttending = attending
            self.guideName = guideName
        }
        else {
            self.isTicket = true
        }
        
        self.eventId = eventId
        self.name = name
        self.creationDate = creationDateString.dateFromString
        self.expirationDate = expirationDate.dateFromString
        self.eventType = EventType(with: eventTypeJson)
        self.quota = quota
        
        if let coordinatesJson = locationJson["coordinates"] as? [Any],
            let long = coordinatesJson[0] as? Double,
            let lat = coordinatesJson[1] as? Double {
            self.location = CLLocationCoordinate2D(latitude: lat, longitude: long)
            self.annotation = EventAnnotation(title: self.name, coordinate: self.location, subtitle: nil)
            self.annotation?.eventId = self.eventId
        }
        
        
    }
    
    var isValidForRequest: Bool {
        if !self.name.isEmpty,
            self.creationDate != nil,
            self.expirationDate != nil,
            self.location != nil,
            self.eventType != nil,
            self.quota != 0 {
            return true
        }

        return false
    }
    
}
