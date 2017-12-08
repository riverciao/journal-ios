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
    
    let pictureContainerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(r: 26, g: 34, b: 38)
        imageView.image = #imageLiteral(resourceName: "icon_photo").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = UIColor(r: 171, g: 179, b: 176)
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
        button.backgroundColor = UIColor(r: 237, g: 96, b: 81)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 22
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

        
        self.view.backgroundColor = UIColor.white
        
        //TODO: hide nav bar but show button
        self.navigationController?.navigationBar.isTranslucent = true
        
        //add addANewArticle navigationItem at leftside
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(dismiss(sender:)))
        
        setupPictureContainerImageView()
        setupInputsContainerView()
        setupPostButton()
    }
    
    private func setupPictureContainerImageView() {
        view.addSubview(pictureContainerImageView)
        
        pictureContainerImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        pictureContainerImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        pictureContainerImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pictureContainerImageView.heightAnchor.constraint(equalToConstant: 375).isActive = true
    }
    
    func setupInputsContainerView() {
        view.addSubview(inputsContainerView)
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: pictureContainerImageView.bottomAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 228).isActive = true
        
        inputsContainerView.addSubview(titleTextField)
        inputsContainerView.addSubview(contentTextField)
        inputsContainerView.addSubview(titleSeparatorView)
        
        titleTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        titleTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 10).isActive = true
        titleTextField.widthAnchor.constraint(equalToConstant: 331).isActive = true
        titleTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        titleSeparatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        titleSeparatorView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        titleSeparatorView.widthAnchor.constraint(equalToConstant: 331).isActive = true
        titleSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        contentTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        contentTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        contentTextField.widthAnchor.constraint(equalToConstant: 331).isActive = true
        contentTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 3/4).isActive = true
    }
    
    func setupPostButton() {
        view.addSubview(postButton)
        
        postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc func dismiss(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //get the status bar to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
