//
//  CreateEventTableViewController.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 25/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit
import MapKit

class CreateEventTableViewController: UITableViewController {

    @IBOutlet weak var segmentGroupType: UISegmentedControl!
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblQuota: UILabel!
    @IBOutlet weak var sliderQuota: UISlider!
    @IBOutlet weak var lblAddress: UILabel!
    
    fileprivate var dateFrom = Date()
    fileprivate var dateTo = Date()
    fileprivate var coordinate: CLLocationCoordinate2D!
    fileprivate var quota = 0
    fileprivate var groupType = GroupType.privateGroup
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.lblSelectedDate.text = "\(self.dateFrom.forDateSelectionString) - \(self.dateTo.forDateSelectionString)"
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
    }
    
    // MARK: - IBActions
    @IBAction func btnSavePressed(_ sender: UIBarButtonItem) {
        if self.txtName.text!.isEmpty {
            self.alert(title: NSLocalizedString("warning", comment: ""), message: NSLocalizedString("empty_field", comment: ""))
            return
        }
        
        
        let event = Event(name: self.txtName.text!
            , creationDate: self.dateFrom, expirationDate: self.dateTo, location: self.coordinate, eventType: EventType(key: "Food", value: "Food"), groupType: self.groupType, quota: self.quota)
        event.create()
    }
    
    @IBAction func sliderQuotaValueChanged(_ sender: UISlider) {
        self.quota = Int(sender.value)
        self.lblQuota.text = NSLocalizedString("quota", comment: "") + ": \((self.quota))"
    }
    
    @IBAction func segmentGroupTypeValueChanged(_ sender: UISegmentedControl) {
        self.groupType = sender.selectedSegmentIndex == 0 ? .privateGroup : .publicGroup
        self.tableView.reloadData()
    }
}

// MARK: - TableView Delegate
extension CreateEventTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isPrivate = self.segmentGroupType.selectedSegmentIndex == 0
        if isPrivate {
            switch indexPath.section {
            case 0, 3:
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
            case 0, 3:
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
        self.dateFrom = date
    }
    
    func dateUntilUpdated(date: Date) {
        self.dateTo = date
    }
    
}

// MARK: - AddressSelector Delegate
extension CreateEventTableViewController: AddressSelectionDelegate {
    
    func addressUpdated(coordinate: CLLocationCoordinate2D, address: String?) {
        self.coordinate = coordinate
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
