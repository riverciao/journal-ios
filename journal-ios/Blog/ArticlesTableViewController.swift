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
    
    var newArticle = Article()
    var articles: [Article] = []
    let cellId = "cellId"
    let ref = Database.database().reference(fromURL: "https://chatroom-1fd12.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Journals"
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: cellId)
        
        let postsRef = Database.database().reference().child("posts")
        postsRef.keepSynced(true)

        
        //add addANewArticle navigationItem at rightside
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addANewArticle(sender:)))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.articles.insert(newArticle, at: 0)
        print("OO\(articles)")
        print("OOOO\(articles.count)")
        print("OOOO\(articles[0].title)")
        
        self.tableView.reloadData()
//        if let newArticle = self.newArticle {
//
//        }
        
        
//        fetchArticle()
//        test()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 212
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var articleCell = ArticleCell()
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ArticleCell {

            let article = articles[indexPath.row]
            
            if let title = article.title {
                cell.pictureImageView.image = #imageLiteral(resourceName: "icon_photo")
                cell.titleLabel.text = title
            }
//                cell.tag = indexPath.row

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
                    
                    self.articles.insert(article, at: 0)
                    
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
        self.navigationController?.pushViewController(postViewController, animated: true)
//        let navController = UINavigationController(rootViewController: postViewController)
//        present(navController, animated: true, completion: nil)
    }

    
}


    

    


