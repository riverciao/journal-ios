//
//  ChatTableViewController.swift
//  ChatRoom
//
//  Created by riverciao on 2017/12/3.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import UIKit
import Firebase

class ChatTableViewController: UITableViewController {

    var users = [User]()
    var recipientUser: User?
    var messages: [Message] = []
    var messagesDictionary: [String: Message] = [:]
    let userCellId = "userCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserCell.self , forCellReuseIdentifier: userCellId)
        fetchUser()

        
        //add showChatLogController navigationItem at rightside
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(showUserTableViewController(sender:)))

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //set up navigation item title
        setupCurrentUser()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var userCell = UserCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: userCellId, for: indexPath) as?  UserCell {
        
            let message = messages[indexPath.row]
            
            let chatPartnerId = message.getChatPartnerId()
            
            if let id = chatPartnerId {
                let ref = Database.database().reference().child("users").child(id)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        
                        cell.textLabel?.text = dictionary["name"] as? String
                        
                    }
                }, withCancel: nil)
            }
            
            cell.detailTextLabel?.text = message.text
            
            
            if let timestamp = message.timestamp {
                let timestampDate = Date(timeIntervalSinceNow: Double(timestamp))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                cell.timeLabel.text = dateFormatter.string(from: timestampDate)
            }
            
            userCell = cell
        }
        
        return userCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if messages.count > indexPath.row {
//            recipientUser = users[indexPath.row]
            let message = messages[indexPath.row]
            guard let chatPartnerId = message.getChatPartnerId() else { return }
            
            let ref = Database.database().reference().child("users").child(chatPartnerId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                var user = User()
                user.id = chatPartnerId
                user.email = dictionary["email"] as? String
                user.firstName = dictionary["first_name"] as? String
                user.lastName = dictionary["last_name"] as? String
                user.name = dictionary["name"] as? String
                
                self.showChatLogController(user: user)
                
            }, withCancel: nil)
        }
    }
    
    private func fetchUser() {
        Database.database().reference().child("users").observe( .childAdded) { (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let firstName = dictionary["first_name"] as? String, let lastName = dictionary["last_name"] as? String, let email = dictionary["email"] as? String {

                    var user = User()

                    user.id = snapshot.key
                    user.firstName = firstName
                    user.lastName = lastName
                    user.email = email

                    self.users.append(user)

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func setupCurrentUser() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observe( .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var user = User()
                user.id = snapshot.key
                user.firstName = dictionary["first_name"] as? String
                user.lastName = dictionary["last_name"] as? String
                user.email = dictionary["email"] as? String
                
                self.setupNavBarWithUser(user: user)
                
//                self.navigationItem.title = dictionary["name"] as? String
                
            }
            
        })
    }
    
    private func setupNavBarWithUser(user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
        if let firstName = user.firstName, let lastName = user.lastName {
            self.navigationItem.title = "\(firstName) \(lastName)"
        }
        
    }
    
    private func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe( .childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value, with: { (messageSnapshot) in
                
                if let dictionary = messageSnapshot.value as? [String: AnyObject] {
                    guard let fromId = dictionary["fromId"] as? String, let toId = dictionary["toId"] as? String, let text = dictionary["text"] as? String, let timestamp = dictionary["timestamp"] as? Int else { return }
                    
                    let message = Message(fromId: fromId, toId: toId, text: text, timestamp: timestamp)
                    
                    
                    if let toId = message.toId {
                        self.messagesDictionary[toId] = message
                        
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            
                            if let message1Timestamp = message1.timestamp, let message2Timestamp = message2.timestamp {
                                return message1Timestamp > message2Timestamp
                            }
                            
                            return true
                        })
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    private func observeMessages() {
        
        let ref = Database.database().reference().child("messages")
        ref.observe( .childAdded, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject] {
                guard let fromId = dictionary["fromId"] as? String, let toId = dictionary["toId"] as? String, let text = dictionary["text"] as? String, let timestamp = dictionary["timestamp"] as? Int else { return }

                let message = Message(fromId: fromId, toId: toId, text: text, timestamp: timestamp)


                if let toId = message.toId {
                    self.messagesDictionary[toId] = message

                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in

                        if let message1Timestamp = message1.timestamp, let message2Timestamp = message2.timestamp {
                            return message1Timestamp > message2Timestamp
                        }

                        return true
                    })
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            }

        }, withCancel: nil)
    }
    
    private func showChatLogController(user: User) {
        let chatLogController = ChatLogController(user: user)
        chatLogController.user = user
        self.navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc private func showUserTableViewController(sender: UIBarButtonItem? = nil) {
        let userTableViewController = UserTableViewController()
        userTableViewController.recipientUser = self.recipientUser
        self.navigationController?.pushViewController(userTableViewController, animated: true)
    }
}

