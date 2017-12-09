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
    
    var newArticle: Article?
    var newImage: UIImage?
    var images: [UIImage] = []
    var articles: [Article] = []
    let cellId = "cellId"
    
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
        
        if let newArticle = self.newArticle, let newImage = self.newImage {
            self.articles.insert(newArticle, at: 0)
            self.images.insert(newImage, at: 0)
        }
        
        self.tableView.reloadData()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
            let image = images[indexPath.row]
            
            if let title = article.title {
                cell.pictureImageView.image = image
                cell.titleLabel.text = title
            }

            articleCell = cell
            
        }
        return articleCell
    }
    
    
    @objc func addANewArticle(sender: UIBarButtonItem) {
        let postViewController = PostViewController()
        self.navigationController?.pushViewController(postViewController, animated: true)
    }

    
}


    

    


