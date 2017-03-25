//
//  Event.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import Foundation
import MapKit

enum GroupType: String {
    case privateGroup = "Private"
    case publicGroup = "Public"
}

class Event {
    var name: String!
    var creationDate: Date!
    var expirationDate: Date!
    var location: CLLocationCoordinate2D!
    var eventType: EventType!
    var groupType: GroupType!
    var quota: Int!
    
    var annotation: EventAnnotation?
    
    init() {}
    
    init(name: String = "", creationDate: Date, expirationDate: Date, location: CLLocationCoordinate2D, eventType: EventType, groupType: GroupType, quota: Int) {
        self.name = name
        self.creationDate = creationDate
        self.expirationDate = expirationDate
        self.location = location
        self.eventType = eventType
        self.groupType = groupType
        self.quota = quota
    }
    
    init?(with json: [String: Any]) {
        print(json)
        guard
            let name = json["name"] as? String,
            let creationDateString = json["creationDate"] as? String,
            let expirationDate = json["expirationDate"] as? String,
            let locationJson = json["location"] as? [String: Any],
            let eventType = json["eventType"] as? [String: Any],
            let groupTypeString = json["groupType"] as? String,
            let quota = json["quota"] as? Int
            else { return nil }
        
        self.name = name
        self.creationDate = creationDateString.dateFromString
        self.expirationDate = expirationDate.dateFromString
        self.eventType = EventType(with: eventType)
        self.groupType = GroupType(rawValue: groupTypeString)
        self.quota = quota
        
        if let coordinatesJson = locationJson["coordinates"] as? [Any],
            let lat = coordinatesJson[0] as? Double,
            let long = coordinatesJson[1] as? Double {
            self.location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        
    }
    
    var isValidForRequest: Bool {
        if self.groupType == GroupType.privateGroup,
            self.creationDate != nil,
            self.expirationDate != nil,
            self.location != nil,
            self.eventType != nil{
            return true
        }
        else if self.groupType == GroupType.publicGroup,
            !self.name.isEmpty,
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
