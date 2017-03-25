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
    
    
    var name: String
    var creationDate: Date
    var expirationDate: Date
    var location: CLLocationCoordinate2D
    var eventType: EventType
    var groupType: GroupType
    var quota: Int
    
    var annotation: EventAnnotation?
    
    
    init(name: String = "", creationDate: Date, expirationDate: Date, location: CLLocationCoordinate2D, eventType: EventType, groupType: GroupType, quota: Int) {
        self.name = name
        self.creationDate = creationDate
        self.expirationDate = expirationDate
        self.location = location
        self.eventType = eventType
        self.groupType = groupType
        self.quota = quota
    }
}
