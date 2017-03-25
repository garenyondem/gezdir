//
//  MapViewController.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBAction func rewindToMapVC(segue: UIStoryboardSegue) {}
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var eventList = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loggedIn), name: Notification.Name.loggedIn , object: nil)
        
        guard User.current != nil else {
            self.performSegue(withIdentifier: "sgLogin", sender: nil)
            return
        }
    
        self.refreshEvents()
    }
    
    func loggedIn() {
        self.refreshEvents()
    }
    
    private func refreshEvents() {
        //Event.events(around: <#T##CLLocationCoordinate2D#>, for: <#T##Int#>, completion: <#T##([Event], API.RequestError) -> Void#>)
    }

}

// MARK: - Functions 
extension MapViewController {
    fileprivate func populateMap(with events: [Event]) {
        events.forEach { event in
            
            // TODO: add event annotation to map
            
            if let annotation = event.annotation {
                self.add(annotation: annotation)
            }
            
            
        }
    }
    
    private func add(annotation: EventAnnotation) {
        print(annotation.coordinate)
        //let circle = MKCircle(center: coordinate, radius: self.radius)
        
        //self.mapView.add(circle)
        self.mapView.addAnnotation(annotation)
        
    }
}

