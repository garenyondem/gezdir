//
//  SelectDateTableViewController.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 25/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit

protocol DateSelectorDelegate {
    func dateFromUpdated(date: Date)
    func dateUntilUpdated(date: Date)
}
class SelectDateTableViewController: UITableViewController {

    @IBOutlet weak var datePickerFrom: UIDatePicker!
    
    @IBOutlet weak var datePickerTo: UIDatePicker!
    
    var delegate: DateSelectorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate?.dateFromUpdated(date: self.datePickerFrom.date)
        self.delegate?.dateUntilUpdated(date: self.datePickerTo.date)
    }
    
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        
        if sender == self.datePickerFrom {
            self.delegate?.dateFromUpdated(date: sender.date)
        }
        else {
            self.delegate?.dateUntilUpdated(date: sender.date)
        }
    }
}
