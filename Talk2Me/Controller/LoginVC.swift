//
//  ViewController.swift
//  Talk2Me
//
//  Created by Jade Kim on 12/4/17.
//  Copyright © 2017 Jade Kim. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordFidle: UITextField!
 
    
    var userUid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: "uid"){
            
            performSegue(withIdentifier: "toChat", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSignIn" {
            
            if let destination = segue.destination as? SignInVC {
                
                if self.userUid != nil {
                    destination.userUid = userUid
                }
                
                if self.emailField.text != nil {
                    destination.emailField = emailField.text
                }
                if self.passwordFidle.text != nil {
                    destination.passwordField = passwordFidle.text
                }
            }
        }
    }

    //signin action
        @IBAction func SignIn (_ sender: AnyObject) {
        
        if let email = emailField.text, let password = passwordFidle.text {
            Auth.auth().signIn(withEmail: email, password: password, completion:
                {(user, error) in
                    
                if error == nil {
                    
                    self.userUid = user?.uid
                    KeychainWrapper.standard.set(self.userUid, forKey: "uid")
                    self.performSegue(withIdentifier: "toChat", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "toSignIn", sender: nil)}
            })
        }
    }
    
}

