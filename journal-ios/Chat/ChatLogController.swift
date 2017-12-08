//
//  ChatLogController.swift
//  ChatRoom
//
//  Created by riverciao on 2017/12/3.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
//    var user: User?
    var recipientUser: User?
    var messages: [Message] = []
    let messageCell = "MessageCell"
    
    var user: User? {
        didSet {
            self.navigationItem.title = user?.name
            
            observeMessages()
        }
    }
    
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    var contentViewHeight: CGFloat {
        get {
            if let naviBarHeight = self.navigationController?.navigationBar.bounds.height,
                let tabBarHeight = self.tabBarController?.tabBar.frame.height {
                return UIScreen.main.bounds.height - naviBarHeight - tabBarHeight - statusBarHeight
            } else {
                return UIScreen.main.bounds.height - statusBarHeight
            }
        }
    }
    
    let messageTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    init(user: User?) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.register(UITableViewCell.self, forCellReuseIdentifier: messageCell)
        messageTableView.dataSource = self
        messageTableView.delegate = self
        

//        self.navigationItem.title = self.user?.name
        
        messageTableView.alwaysBounceVertical = true
        
        //add back navigationItem at leftside and pass messages back from ChatLogController
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(backToChatTableViewController(sender:)))
        
        view?.backgroundColor = UIColor.white
        
        setupInputComponents()
        setupMessageTableView()
        
        observeMessages()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: messageCell)
        
        let message = messages[indexPath.row]
        if let toId = message.toId {
            let ref = Database.database().reference().child("users").child(toId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    
                    cell.textLabel?.text = dictionary["name"] as? String
                    
                }
            }, withCancel: nil)
        }
        
        cell.detailTextLabel?.text = message.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    private func setupMessageTableView() {
        view.addSubview(messageTableView)
        
        messageTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messageTableView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        messageTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        messageTableView.heightAnchor.constraint(equalToConstant: contentViewHeight - containerView.bounds.height).isActive = true
    }
    
    
    private func setupInputComponents() {
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend(sender:)), for: .touchUpInside)
        containerView.addSubview(sendButton)

        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true

        containerView.addSubview(inputTextField)

        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true

        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)

        separatorLineView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        let tabBarSeparatorLineView = UIView()
        tabBarSeparatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        tabBarSeparatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tabBarSeparatorLineView)

        tabBarSeparatorLineView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        tabBarSeparatorLineView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        tabBarSeparatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        tabBarSeparatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    
    @objc private func handleSend(sender: UIButton? = nil) {
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
//        guard let recipientUser = self.recipientUser, let toId = recipientUser.id, let fromId = Auth.auth().currentUser?.uid else { return }
        
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSinceNow)
        
        
        let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String: Any]
        
        
        
        childRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId: 1])
        }
    }
    
    private func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userMessageRef = Database.database().reference().child("user-messages").child(uid)
        userMessageRef.observe(.childAdded, with: { (snapashot) in

            let messageId = snapashot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (messageSnapshot) in
                
                guard let dictionary = messageSnapshot.value as? [String: AnyObject] else { return }
                var message = Message()
                message.fromId = dictionary["fromId"] as? String
                message.text = dictionary["text"] as? String
                message.timestamp = dictionary["timestamp"] as? Int
                message.toId = dictionary["toId"] as? String
                
                if message.getChatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.messageTableView.reloadData()
                    }
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    
    }
    
//    private func observeMessages() {
//        let ref = Database.database().reference().child("messages")
//        ref.observe( .childAdded, with: { (snapshot) in
//
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                guard let fromId = dictionary["fromId"] as? String, let toId = dictionary["toId"] as? String, let text = dictionary["text"] as? String, let timestamp = dictionary["timestamp"] as? Int else { return }
//
//                let message = Message(fromId: fromId, toId: toId, text: text, timestamp: timestamp)
//                self.messages.append(message)
//                print(message)
//
//                DispatchQueue.main.async {
//                    self.messageTableView.reloadData()
//                }
//
//            }
//
//        }, withCancel: nil)
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    @objc private func backToChatTableViewController(sender: UIBarButtonItem? = nil) {
        
        let chatTableViewController = self.navigationController?.viewControllers[0] as? ChatTableViewController
        chatTableViewController?.messages = self.messages
        self.navigationController?.popViewController(animated: true)
    }
}
