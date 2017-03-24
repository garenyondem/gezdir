//
//  EventAnnotation.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit
import MapKit

class EventAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    
    var overlay: MKCircle!
    
    init(title: String?, coordinate: CLLocationCoordinate2D, subtitle: String?) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }
}

