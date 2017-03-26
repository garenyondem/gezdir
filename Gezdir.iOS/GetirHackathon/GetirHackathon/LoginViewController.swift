//
//  LoginViewController.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit
import Spring

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtMail: SpringTextField!
    @IBOutlet weak var txtPassword: SpringTextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnLoginPressed(_ sender: UIButton) {
        var isValid = true
        
        if self.txtMail.text!.isEmpty  {
            self.txtMail.animation = "shake"
            self.txtMail.animate()
            isValid = false
        }
        
        if self.txtPassword.text!.isEmpty {
            self.txtPassword.animation = "shake"
            self.txtPassword.animate()
            isValid = false
        }
        
        guard isValid else { return }
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
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
