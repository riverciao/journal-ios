//
//  ArticlesTableViewController.swift
//  ChatRoom
//
//  Created by riverciao on 2017/11/24.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import UIKit
import Firebase

class ArticlesTableViewController: UITableViewController {
    
    var articleList = [Article]()
    let cellId = "cellId"
    let ref = Database.database().reference(fromURL: "https://chatroom-1fd12.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: cellId)
        
        let postsRef = Database.database().reference().child("posts")
        postsRef.keepSynced(true)

        
        //add addANewArticle navigationItem at rightside
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addANewArticle(sender:)))
        
//        checkIfUserIsLoggedIn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        fetchArticle()
        test()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var articleCell = ArticleCell()
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ArticleCell {

            let article = articleList[indexPath.row]
            cell.textLabel?.text = article.title
            cell.detailTextLabel?.text = article.content

            cell.tag = indexPath.row

            articleCell = cell
            
        }
        return articleCell
    }
    
    func test() {
        
        let ref = Database.database().reference().child("posts")
        
        ref.observe(.value, with: { (snapshot) in
            
            print("OOOO\(snapshot)")
            
        }, withCancel: nil)
    }
    
    func fetchArticle() {
        
        Database.database().reference().child("posts").observe( .childAdded) { (snapshots) in

            if let dictionary  = snapshots.value as? [String: AnyObject] {
                if let title = dictionary["title"] as? String, let content = dictionary["content"] as? String {
                    
                    var article = Article()
                    
                    // if use this setter, your app will crash if your class properties don't exactly match with the firebase dictionary keys
                    //article.setValuesForKeys(dictionary)
                    
                    //safer way
                    article.title = title
                    article.content = content
                    
                    self.articleList.insert(article, at: 0)
                    
                    DispatchQueue.main.async {
                        //this will crash because of background thread, so put it in async
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func addANewArticle(sender: UIBarButtonItem) {
        let postViewController = PostViewController()
        let navController = UINavigationController(rootViewController: postViewController)
        present(navController, animated: true, completion: nil)
    }

    
}

class ArticleCell: UITableViewCell {
    var publishDateLabel = UILabel()
    var authorLabel = UILabel()
    var likeButton = UIButton(type: .custom)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        
        publishDateLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(publishDateLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(likeButton)
        
        let image = UIImage(named: "icon-heart")?.withRenderingMode(.alwaysTemplate)
        likeButton.setImage(image, for: .normal)

        
        likeButton.rightAnchor.constraint(equalTo: authorLabel.leftAnchor, constant: -2).isActive = true
        likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        authorLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2).isActive = true
        authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive = true
        authorLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        publishDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2).isActive = true
        publishDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        publishDateLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
        publishDateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

