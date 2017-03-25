//
//  EventDetailsViewController.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 25/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit
import MapKit

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblGuideName: UILabel!
    @IBOutlet weak var lblAtendeeCount: UILabel!
    @IBOutlet weak var btnAttend: UIButton!
    
    var event: Event!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(event != nil, "Event cannot be nil")
    }
    
    @IBAction func btnAttendPressed(_ sender: UIButton) {
        
    }
    
}
