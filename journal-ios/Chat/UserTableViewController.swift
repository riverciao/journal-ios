//
//  UserTableViewController.swift
//  ChatRoom
//
//  Created by riverciao on 2017/12/6.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewController: UITableViewController {

    var users = [User]()
    var recipientUser: User?
    let userCellId = "userCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserCell.self , forCellReuseIdentifier: userCellId)
        fetchUser()
        
        //set up navigation item title
        setupCurrentUser()
    }


    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var userCell = UserCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: userCellId, for: indexPath) as?  UserCell {
            
            let user = users[indexPath.row]

            if let firstName = user.firstName, let lastName = user.lastName, let email = user.email {
                cell.textLabel?.text = "\(firstName) \(lastName)"
                cell.detailTextLabel?.text = email
            }
            
            userCell = cell
        }
        
        return userCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
    private func setupCurrentUser() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observe( .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
            }
            
        })
    }
    
    @objc private func showChatLogController(sender: UIBarButtonItem? = nil) {
//        let chatLogController = ChatLogController(user: )
//        chatLogController.recipientUser = self.recipientUser
//        self.navigationController?.pushViewController(chatLogController, animated: true)
    }

}
