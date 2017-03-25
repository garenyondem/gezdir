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
    @IBOutlet weak var holderView: UIView!
    
    var event: Event!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(event != nil, "Event cannot be nil")
        
        self.btnAttend.setTitle(NSLocalizedString("Attending...", comment: ""), for: .disabled)
        self.btnAttend.setTitleColor(.lightGray, for: .disabled)
        if self.event.isAttending {
            self.btnAttend.isEnabled = false
            self.btnAttend.setTitle(NSLocalizedString("attending", comment: ""), for: .disabled)
            self.btnAttend.backgroundColor = .green
        }
        
        self.lblEventName.text = self.event.name
        self.lblGuideName.text = self.event.guideName
        self.lblAtendeeCount.text = "\(self.event.attendeeCount!)/\(self.event.quota!)"
        self.mapView.setRegion(MKCoordinateRegion(center: self.event.location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        self.add(annotation: self.event.annotation!)
        
        
    }
    
    private func add(annotation: EventAnnotation) {
        self.mapView.addAnnotation(annotation)
    }
    
    @IBAction func btnAttendPressed(_ sender: UIButton) {
        self.btnAttend.isEnabled = false
        self.event.attend { [weak self] error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self?.alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("an_error_occured", comment: ""))
                    self?.btnAttend.isEnabled = true
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.alert(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("reservation_complete", comment: ""))
                self?.btnAttend.setTitle(NSLocalizedString("attending", comment: ""), for: .disabled)
                self?.event.isAttending = true
                self?.event.attendeeCount = (self?.event.attendeeCount)! + 1
                self?.lblAtendeeCount.text = "\(self!.event.attendeeCount!)/\(self!.event.quota!)"
                self?.btnAttend.backgroundColor = .green
            }
            
        }
    }
    
}
