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
    
    var items: [Item] = []
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Journals"
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: cellId)
        
        //add addANewArticle navigationItem at rightside
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addANewArticle(sender:)))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        items = CoreDataHandler.fetchObject()!
        
        //TODO: - adjust the order of journey
//        self.items.sort(by: { (item1, item2) -> Bool in
//
//            return item2.timestamp > item1.timestamp
//        })
        
        self.tableView.reloadData()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 212
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var articleCell = ArticleCell()
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ArticleCell {
            
            let article = items[indexPath.row]
            
            
            if items.count > indexPath.row {
                
                if let title = article.title {
                    cell.titleLabel.text = title
                }
                
                if let imageData = article.image {
                    if let image = UIImage(data: imageData) {
                        cell.pictureImageView.image = image
                    }
                }
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


    

    


