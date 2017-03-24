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
        
        self.btnLogin.isEnabled = false
        self.btnLogin.setTitle(NSLocalizedString("logging_in", comment: ""), for: .disabled)
        
        let user = User(mail: self.txtMail.text!, password: self.txtPassword.text!)
        user.login { error in
            
            if  error != nil,
                case API.RequestError.serverSide(let message) = error! {
                DispatchQueue.main.async {
                    self.btnLogin.isEnabled = true
                    self.alert(title: NSLocalizedString("error", comment: ""), message: message)
                }
                return
            }
            else if error != nil {
                DispatchQueue.main.async {
                    self.btnLogin.isEnabled = true
                    self.alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("an_error_occured", comment: ""))
                }
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
}
