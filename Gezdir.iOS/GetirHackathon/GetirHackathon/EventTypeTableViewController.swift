//
//  EventTypeTableViewController.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 25/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit

protocol EventTypeSelectionDelegate {
    func eventTypeSelected(eventType: EventType)
}

class EventTypeTableViewController: UITableViewController {

    var eventTypeList = [EventType]()
    
    var delegate: EventTypeSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        EventType.eventTypes { [weak self] (eventTypeList, error) in
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
            
            self?.eventTypeList = eventTypeList!
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventTypeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.eventTypeList[indexPath.row].value
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.eventTypeSelected(eventType: self.eventTypeList[indexPath.row])
        _ = self.navigationController?.popViewController(animated: true)
    }

}
