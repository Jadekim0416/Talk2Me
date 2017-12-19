//
//  HomeVC.swift
//  Talk2Me
//
//  Created by Jade Kim on 12/18/17.
//  Copyright © 2017 Jade Kim. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class HomeVC: UIViewController, UINavigationControllerDelegate {
    
    @IBAction func editProfile (_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "toSignIn", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
