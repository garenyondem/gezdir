//
//  CreateEventTableViewController.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 25/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit
import MapKit

protocol CreateEventDelegate {
    func eventCreated(event: Event)
}

class CreateEventTableViewController: UITableViewController {
    @IBOutlet weak var segmentGroupType: UISegmentedControl!
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblQuota: UILabel!
    @IBOutlet weak var sliderQuota: UISlider!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblEventType: UILabel!
    
    fileprivate var event: Event!
    
    var delegateEventCreation: CreateEventDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.event = Event()
        self.event.quota = 0
        self.event.groupType = GroupType.privateGroup
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateSelectedDate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    fileprivate func updateSelectedDate() {
        guard
            let creationDate = self.event.creationDate,
            let expirationDate = self.event.expirationDate
        else { return }
        
        self.lblSelectedDate.text = "\(creationDate.forDateSelectionString) - \(expirationDate.forDateSelectionString)"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgDate" {
            let vc = segue.destination as! SelectDateTableViewController
            vc.delegate = self
        }
        else if segue.identifier == "sgAddress" {
            let vc = segue.destination as! SelectAddressViewController
            vc.delegate = self
        }
        else if segue.identifier == "sgEventType" {
            let vc = segue.destination as! EventTypeTableViewController
            vc.delegate = self
        }
    }
    
    // MARK: - IBActions
    @IBAction func btnSavePressed(_ sender: UIBarButtonItem) {
        if self.txtName.text!.isEmpty && self.event.groupType == GroupType.publicGroup {
            self.alert(title: NSLocalizedString("warning", comment: ""), message: NSLocalizedString("empty_field", comment: ""))
            return
        }
        
        self.event.name = self.txtName.text
        
        if self.event.isValidForRequest {
            self.event.create(completion: { [weak self] (event, error) in
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
                
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                    self?.delegateEventCreation?.eventCreated(event: event!)
                }
            })
                
        
        }
    }
    
    @IBAction func sliderQuotaValueChanged(_ sender: UISlider) {
        self.event.quota = Int(sender.value)
        self.lblQuota.text = NSLocalizedString("quota", comment: "") + ": \((self.event.quota!))"
    }
    
    @IBAction func segmentGroupTypeValueChanged(_ sender: UISegmentedControl) {
        self.event.groupType = sender.selectedSegmentIndex == 0 ? .privateGroup : .publicGroup
        self.tableView.reloadData()
    }
}

// MARK: - TableView Delegate
extension CreateEventTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isPrivate = self.segmentGroupType.selectedSegmentIndex == 0
        if isPrivate {
            switch indexPath.section {
            case 0, 4:
                return 0.1
            default:
                return 52
            }
        }
        return 52
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let isPrivate = self.segmentGroupType.selectedSegmentIndex == 0
        if isPrivate {
            switch section {
            case 0, 4:
                return 0.1
            default:
                return 22
            }
        }
        return 22
    }
}

// MARK: - DateSelector Delegate
extension CreateEventTableViewController: DateSelectorDelegate {
    
    func dateFromUpdated(date: Date) {
        self.event.creationDate = date
    }
    
    func dateUntilUpdated(date: Date) {
        self.event.expirationDate = date
    }
    
}

// MARK: - AddressSelector Delegate
extension CreateEventTableViewController: AddressSelectionDelegate {
    
    func addressUpdated(coordinate: CLLocationCoordinate2D, address: String?) {
        self.event.location = coordinate
        self.lblAddress.text = NSLocalizedString("address_selected", comment: "")
    }
    
}

// MARK: - TextField Delegate
extension CreateEventTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - EventTypeSelection Delegate
extension CreateEventTableViewController: EventTypeSelectionDelegate {
    func eventTypeSelected(eventType: EventType) {
        self.event.eventType = eventType
        self.lblEventType.text = eventType.value
    }
}
