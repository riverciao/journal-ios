//
//  PostViewController.swift
//  ChatRoom
//
//  Created by riverciao on 2017/11/26.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {

    var currentUserName: String?
    let ref = Database.database().reference(fromURL: "https://chatroom-1fd12.firebaseio.com/")
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    let titleTextField: UITextField = {
        let textFeild = UITextField()
        textFeild.placeholder = "Title"
        textFeild.translatesAutoresizingMaskIntoConstraints = false
        return textFeild
    }()
    
    let titleSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contentTextField: UITextField = {
        let textFeild = UITextField()
        textFeild.placeholder = "Content"
        textFeild.translatesAutoresizingMaskIntoConstraints = false
        return textFeild
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(postANewArticle(sender:)), for: .touchUpInside)
        return button
    }()
    
    @objc func postANewArticle(sender: UIButton) {
        guard let title = titleTextField.text, let content = contentTextField.text, let author = currentUserName else {
            print("Form is not valid")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        
//        let ref = Database.database().reference(fromURL: "https://chatroom-1fd12.firebaseio.com/")
        let values = ["title": title, "content": content, "date": dateString, "author": author]
        
        if title != "" {
//            ref.child("posts").childByAutoId().setValue(values)
            ref.child("posts").childByAutoId().onDisconnectSetValue(values)
            
        } else {
            // TODO: -warning user to type in title
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase Offline Setup
        ref.keepSynced(true)

        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputsContainerView)
        view.addSubview(postButton)
        
        setupInputsContainerView()
        setupPostButton()
        
        //add Back navigationItem at laftside
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backToArticleList(sender:)))
        
        getAuthorName()
    }
    
    func getAuthorName() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observe(.value) { (snapshot) in
            
            if let dictionary  = snapshot.value as? [String: AnyObject] {
                self.currentUserName = dictionary["name"] as? String
            }
        }
    }
    
    func setupPostButton() {
        postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        postButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupInputsContainerView() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalToConstant: view.bounds.width - 24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        inputsContainerView.addSubview(titleTextField)
        inputsContainerView.addSubview(contentTextField)
        inputsContainerView.addSubview(titleSeparatorView)
        
        titleTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        titleTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        titleTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        titleTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        titleSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        titleSeparatorView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        titleSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        titleSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        contentTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        contentTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        contentTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        contentTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 3/4).isActive = true
    }
    
    @objc func backToArticleList(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //get the status bar to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
