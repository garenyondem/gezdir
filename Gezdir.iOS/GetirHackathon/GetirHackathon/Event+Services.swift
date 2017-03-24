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
    private typealias EventListResult = ([Event], API.RequestError) -> Void
    
    static func events(around location: CLLocationCoordinate2D, for userType: Int, completion: EventListResult) {
        
        API.shared.request(endpoint: .events(around: location, userType: userType)) { (data, error) in
            
            
        }
        
    }
    
}
