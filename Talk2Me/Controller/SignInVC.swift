//
//  SignInVC.swift
//  Talk2Me
//
//  Created by Jade Kim on 12/18/17.
//  Copyright © 2017 Jade Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class SignInVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userImagePicker: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var imgCircle: UIImageView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var userUid: String!
    
    var emailField: String!
    
    var passwordField: String!
    
    var imagePicker: UIImagePickerController!
    
    var imageSelected = false
    
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self 
        
        imagePicker.allowsEditing = true
        
        //make image circle
        imgCircle.layer.cornerRadius = imgCircle.frame.size.width/2
        
        imgCircle.clipsToBounds = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            
            performSegue(withIdentifier: "toChat", sender: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            userImagePicker.image = image
            
            imageSelected = true
            
        } else {
            
            print("image wasnt selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setUser(img: String) {
        
        let userData = [
            "username": username!,
            "userImg": img
        ]
        
        KeychainWrapper.standard.set(userUid, forKey: "uid")
        
        let location = Database.database().reference().child("users").child(userUid)
        
        location.setValue(userData)
        
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImg() {
        
        if usernameField.text == nil {
            
           confirmBtn.isEnabled = false
            
        } else {
            
            username = usernameField.text
            
            confirmBtn.isEnabled = true
        }
        
        guard let img = userImagePicker.image, imageSelected == true else {
            
            print("image needs to be selected")
            
            return
       }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            
            let metadata = StorageMetadata()
            
            metadata.contentType = "image/jpeg"
            
            Storage.storage().reference().child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                
                if error != nil {
                    
                    print("did not upload img")
                    
                } else {
                    
                    print("uploaded")
                    
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadURL {
                        
                        self.setUser(img: url)
                    }
                }
            }
        }
    }
    
    
    @IBAction func selectedImgPicker (_ sender: AnyObject) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel (_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save (_ sender: AnyObject) {
        self.performSegue(withIdentifier: "toHome", sender: nil)
        
    }
}


