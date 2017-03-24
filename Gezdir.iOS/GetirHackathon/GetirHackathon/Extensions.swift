//
//  Extensions.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    
    static let loggedIn = Notification.Name("user_loggedIn")
    
}

extension UIViewController {
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }
}
