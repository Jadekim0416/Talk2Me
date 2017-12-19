//
//  ChatVC.swift
//  Talk2Me
//
//  Created by Jade Kim on 12/18/17.
//  Copyright © 2017 Jade Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var chatDatil = [ChatDetail]()
    var detail: ChatDetail!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    var recipient: String!
    var messageID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value, with: {(snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                self.chatDatil.removeAll()
                
                for data in snapshot {
                    if let messageDict = data.value as? Dictionary<String, AnyObject> {
                        let key = data.key
                        
                        let info = ChatDetail(messageKey: key, messageData: messageDict)
                        
                        self.chatDatil.append(info)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    //section
    func  numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDatil.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let chatDet = chatDatil[indexPath.row]
           
            if let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell")as? chatDetailCell {
            
                cell.configureCell(chatDetail: chatDet)
                
                return cell
            } else {
                
            return chatDetailCell()
        }
    }
    
}

