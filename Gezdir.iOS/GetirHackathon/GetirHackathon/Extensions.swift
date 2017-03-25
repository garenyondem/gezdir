//
//  Extensions.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit
import MapKit

extension Notification.Name {
    
    static let loggedIn = Notification.Name("user_loggedIn")
    static let locationUpdated = Notification.Name("user_location_updated")
    
}

extension UIViewController {
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension Date {
    
    var forApiFormatedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd hh:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    var forDateSelectionString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM hh:mm"
        return dateFormatter.string(from: self)
    }
    
}

extension String {
    var dateFromString: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.date(from: self)
    }
}

extension MKMapView {
    
    func removeAllEvents() {
        self.removeOverlays(self.overlays)
        self.removeAnnotations(self.annotations)
    }
    
}
