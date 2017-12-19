//
//  chatDetailCell.swift
//  Talk2Me
//
//  Created by Jade Kim on 12/18/17.
//  Copyright © 2017 Jade Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper

class chatDetailCell: UITableViewCell {
    
    @IBOutlet weak var recpientImg: UIImageView!
    @IBOutlet weak var recpientName: UILabel!
    @IBOutlet weak var chatPreview: UILabel!
    
    var chatDetail: ChatDetail!
    
    var userPostKey: DatabaseReference!
    
    let currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(chatDetail: ChatDetail) {
        self.chatDetail = chatDetail
        
        let recipientData = Database.database().reference().child("users").child(chatDetail.recipient)
        
        recipientData.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            let username = data["username"]
            let userImg = data["userImg"]
            
            self.recpientName.text = username as? String
            
            let ref = Storage.storage().reference(forURL: userImg! as! String)
            
            ref.getData(maxSize: 10000, completion: { (data, error) in
                
                if error != nil {
                    print("cound not load image")
                } else {
                    if let imgData = data {
                        
                        if let img = UIImage(data: imgData) {
                            self.recpientImg.image = img
                        }
                    }
                }
            })
        })
    }

}
