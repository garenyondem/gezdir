//
//  LoginViewController.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btnLoginPressed(_ sender: UIButton) {
        guard !self.txtMail.text!.isEmpty else { return }
        guard !self.txtPassword.text!.isEmpty else { return }
        
        let user = User(mail: self.txtMail.text!, password: self.txtPassword.text!)
        user.login { success, error in
            
            guard error == nil else {
                // TODO: Handle Error
                return
            }
            
            if success {
                // TODO: Main View Controller
            }
            
        }
        
    }
}
