//
//  PostViewController.swift
//  ChatRoom
//
//  Created by riverciao on 2017/11/26.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let pictureContainerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(r: 26, g: 34, b: 38)
        imageView.image = #imageLiteral(resourceName: "icon_photo").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var pickAnImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(goToPickAnImage(sender:)), for: .touchUpInside)
        
        return button
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
        guard let title = titleTextField.text, let content = contentTextField.text else {
            print("Form is not valid")
            return
        }
        
        
        let article = Article(title: title, content: content)
        
        //handle image
        let image = self.pictureContainerImageView.image
        let imageData = UIImageJPEGRepresentation(image!, 1)
        
        //handle timestamp
        let timestamp = Date().timeIntervalSinceNow
        let timestampDate = Date(timeIntervalSinceNow: timestamp)
        
        if let title = article.title, let content = article.content, let imageData = imageData {
            CoreDataHandler.saveObject(title: title, content: content, image: imageData, timestamp: timestampDate)
        }

        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.white
        
        //add addANewArticle navigationItem at leftside
        let image = UIImage(named: "icon-dismiss")?.withRenderingMode(.alwaysTemplate)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .plain, target: self, action: #selector(back(sender:)))
        navigationController?.navigationBar.tintColor = .white
        
        setupPictureContainerImageView()
        setupInputsContainerView()
        setupPostButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
    }
    
    private func setupPictureContainerImageView() {
        view.addSubview(pictureContainerImageView)
        
        pictureContainerImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        pictureContainerImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        pictureContainerImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pictureContainerImageView.heightAnchor.constraint(equalToConstant: 375).isActive = true
        
        view.addSubview(pickAnImageButton)
        
        pickAnImageButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        pickAnImageButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        pickAnImageButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pickAnImageButton.heightAnchor.constraint(equalToConstant: 375).isActive = true
        
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
    
    @objc func back(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goToPickAnImage(sender: UIButton) {
        openGallary()
    }
    
    func openGallary() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pictureContainerImageView.image = image
            pictureContainerImageView.contentMode = .scaleAspectFill
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}
