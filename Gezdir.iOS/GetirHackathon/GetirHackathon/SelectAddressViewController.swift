//
//  SelectAddressViewController.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 25/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit
import MapKit

protocol AddressSelectionDelegate {
    func addressUpdated(coordinate: CLLocationCoordinate2D, address: String?)
}

class SelectAddressViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var delegate: AddressSelectionDelegate?
    fileprivate var mapTapGestureRecognizer: UITapGestureRecognizer!
    
    fileprivate let tableViewController = UITableViewController(style: .plain)
    fileprivate var searchController: UISearchController!
    
    fileprivate var localSearch: MKLocalSearch!
    fileprivate var searchResults = [MKMapItem]()
    
    fileprivate var selectedAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        self.mapView.addGestureRecognizer(self.mapTapGestureRecognizer)
        
        self.tableViewController.tableView.delegate = self
        self.tableViewController.tableView.dataSource = self
        self.searchController = UISearchController(searchResultsController: self.tableViewController)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.placeholder = NSLocalizedString("search_address_or_location", comment: "")
        
        if let location = LocationManager.shared.lastKnownLocation {
            self.mapView.setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: false)
        }
    }

    @IBAction func btnSearchPressed(_ sender: UIBarButtonItem) {
        self.present(self.searchController, animated: true, completion: nil)
    }
    
}

// MARK: - Helper Functions {
extension SelectAddressViewController {
    func mapTapped(_ sender: UITapGestureRecognizer) {
        let pointInView = sender.location(in: self.mapView)
        let coordinateInMap = self.mapView.convert(pointInView, toCoordinateFrom: self.mapView)
        
        self.addPin(to: coordinateInMap)
    }
    
    func addPin(to coordinate: CLLocationCoordinate2D) {
        let annotation = EventAnnotation(title: nil, coordinate: coordinate, subtitle: nil)
        
        let circle = MKCircle(center: coordinate, radius: 1000)
        
        self.mapView.removeAllEvents()
        
        self.mapView.add(circle)
        self.mapView.addAnnotation(annotation)
        
        self.mapView.region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.delegate?.addressUpdated(coordinate: annotation.coordinate, address: nil)
    }
}

// MARK: - MapViewDelegate
extension SelectAddressViewController: MKMapViewDelegate {
    
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
            
            view.animatesDrop = true
            view.canShowCallout = false
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlay = overlay as! MKCircle
        let circleRenderer = MKCircleRenderer(circle: overlay)
        circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
        circleRenderer.strokeColor = .blue
        circleRenderer.lineWidth = 1
        return circleRenderer
    }
}

// MARK: - UISearchBar Delegete
extension SelectAddressViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard !searchController.searchBar.text!.isEmpty else {
            self.searchResults = []
            self.tableViewController.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return
        }
        
        
        if self.localSearch != nil && self.localSearch.isSearching {
            self.localSearch.cancel()
        }
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchController.searchBar.text
        self.localSearch = MKLocalSearch(request: localSearchRequest)
        self.localSearch.start { (response, error) in
            
            guard response != nil else {
                self.searchResults = []
                self.tableViewController.tableView.reloadData()
                return
            }
            
            self.searchResults = response!.mapItems
            self.tableViewController.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
    
}

// MARK: - Results TableView Delegate & Data Sources
extension SelectAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placemark = self.searchResults[indexPath.row].placemark
        self.tableViewController.dismiss(animated: true) {
            self.mapView.removeAllEvents()
            self.mapView.centerCoordinate = placemark.coordinate
            self.addPin(to: placemark.coordinate)
            if let cell = tableView.cellForRow(at: indexPath) {
                self.selectedAddress = cell.textLabel!.text! + " - " + cell.detailTextLabel!.text!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let name = self.searchResults[indexPath.row].name
        let placemark = self.searchResults[indexPath.row].placemark
        cell.textLabel?.text = name
        
        var address = ""
        
        if let city = placemark.locality {
            address = city
        }
        
        if let street = placemark.thoroughfare {
            address += address.isEmpty ? street : ", " + street
        }
        
        cell.detailTextLabel?.text = address
        
        return cell
    }
}

