//
//  MapViewController.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit
import MapKit
import Spring

class MapViewController: UIViewController {

    @IBAction func rewindToMapVC(segue: UIStoryboardSegue) {}
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate var eventList = [Event]()
    
    fileprivate var searchOrCreate: SearchOrCreate?
    
    var selectedEventToShow: Event?
    
    @IBOutlet weak var btnAdd: SpringButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loggedIn), name: Notification.Name.loggedIn , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserLocationOnMap), name: Notification.Name.locationUpdated , object: nil)
        
        self.btnAdd.layer.cornerRadius = self.btnAdd.frame.width/2
        
        guard User.current != nil else {
            self.performSegue(withIdentifier: "sgLogin", sender: nil)
            return
        }
        
        self.btnAdd.animation = "morph"
        self.btnAdd.animate()
        self.updateUserLocationOnMap()
        
        self.refreshEvents()
    }
    
    func loggedIn() {
        self.refreshEvents()
    }
    
    fileprivate func refreshEvents() {
        if let userLocation = LocationManager.shared.lastKnownLocation {
            let isTicket = self.segmentControl.selectedSegmentIndex == 1
            
            Event.fetch(around: userLocation, isTicket: isTicket, completion: { [weak self] (eventList, error) in
                if  error != nil,
                    case API.RequestError.serverSide(let message) = error! {
                    DispatchQueue.main.async {
                        self?.alert(title: NSLocalizedString("error", comment: ""), message: message)
                    }
                    return
                }
                else if error != nil {
                    DispatchQueue.main.async {
                        self?.alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("an_error_occured", comment: ""))
                    }
                    return
                }
                
                self?.eventList = eventList!
                DispatchQueue.main.async {
                    self?.populateMap()
                }
                
            })
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgCreate" {
            if let navigationController = segue.destination as? UINavigationController,
                let vc = navigationController.viewControllers[0] as? CreateEventTableViewController {
                vc.delegateEventCreation = self
                vc.searchOrCreate = self.searchOrCreate
            }
        }
        else if segue.identifier == "sgEventDetails" {
            let vc = segue.destination as! EventDetailsViewController
            vc.event = self.selectedEventToShow
            vc.delegate = self
            self.selectedEventToShow = nil
        }
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        guard self.searchOrCreate != .search else { return }
        self.mapView.removeAllEvents()
        self.refreshEvents()
    }
    
    @IBAction func btnSearchPressed(_ sender: UIBarButtonItem) {
        self.searchOrCreate = .search
        self.performSegue(withIdentifier: "sgCreate", sender: nil)
    }
    
    @IBAction func btnAddPressed(_ sender: UIButton) {
        self.searchOrCreate = .create
    }
}

// MARK: - Functions 
extension MapViewController {
    fileprivate func populateMap() {
        self.mapView.removeAllEvents()
        self.eventList.forEach { event in
            if let annotation = event.annotation {
                self.add(annotation: annotation)
            }
        }
    }
    
    private func add(annotation: EventAnnotation) {
        self.mapView.addAnnotation(annotation)
    }
    
    func updateUserLocationOnMap() {
        if let location = LocationManager.shared.lastKnownLocation {
            self.mapView.setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: false)
            self.refreshEvents()
        }
    }
}

// MARK: - CreateEvent Delegate
extension MapViewController: CreateEventDelegate{
    func eventCreated(event: Event) {
        self.refreshEvents()
    }
    
    func search(with result: [Event], segmentIndex: Int) {
        self.segmentControl.selectedSegmentIndex = segmentIndex
        self.searchOrCreate = nil
        self.eventList = result
        self.populateMap()
    }
}

// MARK: - EventRequest Delegate
extension MapViewController: EventRequestDelegate {
    func requestSucceded() {
        self.refreshEvents()
    }
}

// MARK: - MapView Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is EventAnnotation {
            
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "mypin") as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "mypin")
            }
            
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.tag = annotation.hash
            
            view.animatesDrop = false
            view.canShowCallout = true
            view.rightCalloutAccessoryView = rightButton
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? EventAnnotation {
            if let event = self.eventList.event(by: annotation.eventId) {
                self.selectedEventToShow = event
                self.performSegue(withIdentifier: "sgEventDetails", sender: nil)
            }
            
        }
    }
}

