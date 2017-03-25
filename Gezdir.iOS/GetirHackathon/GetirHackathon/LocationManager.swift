//
//  LocationManager.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 25/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    private override init() {
        self.manager = CLLocationManager()
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
    }
    
    fileprivate var manager: CLLocationManager
    
    var lastKnownLocation: CLLocationCoordinate2D?
    
    func updateLocation() {
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.first?.coordinate {
            self.lastKnownLocation = lastLocation
            
            manager.delegate = nil
            manager.stopUpdatingLocation()
            NotificationCenter.default.post(name: Notification.Name.locationUpdated, object: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.updateLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
