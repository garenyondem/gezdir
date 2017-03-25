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
    typealias EventListResult = ([Event], API.RequestError?) -> Void
    typealias CreateEventResult = (Event?, API.RequestError?) -> Void
    
    static func events(around location: CLLocationCoordinate2D, for userType: Int, completion: EventListResult) {
        
        API.shared.request(endpoint: .events(around: location, userType: userType)) { (jsonObject, error) in
            
            
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
    
}
