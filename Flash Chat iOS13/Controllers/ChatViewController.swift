//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Constants.appName
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        messages = []
        
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener { querySnapShot, error in
                
            if let error = error {
                print(error)
            } else {
                if let snapShotDoc = querySnapShot?.documents {
                    self.messages = snapShotDoc.compactMap{Message(sender: $0.data()[Constants.FStore.senderField] as! String, body: $0.data()[Constants.FStore.bodyField] as! String)}
                
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let message = messageTextfield.text, let sender = Auth.auth().currentUser?.email {
            db.collection(Constants.FStore.collectionName).addDocument(data: [Constants.FStore.senderField: sender,
                 Constants.FStore.bodyField: message,
                 Constants.FStore.dateField: Date().timeIntervalSince1970
                ]) { error in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
                
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myBgYourTxtColor = UIColor(named: Constants.BrandColors.lightPurple)
        let myTxtYourBgColor = UIColor(named: Constants.BrandColors.purple)
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLbl?.text = message.body
        
        let isCurrentUserSender = message.sender == Auth.auth().currentUser?.email
        
        cell.meAvatar.isHidden = !isCurrentUserSender
        cell.youAvatar.isHidden = !cell.meAvatar.isHidden
        cell.messageBubble.backgroundColor = isCurrentUserSender ? myBgYourTxtColor : myTxtYourBgColor
        cell.messageLbl.textColor = isCurrentUserSender ? myTxtYourBgColor : myBgYourTxtColor
        
        return cell
    }
    
}
