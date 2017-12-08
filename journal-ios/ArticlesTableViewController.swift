//
// ArticlesTableViewController.swift
//  journal-ios
//
//  Created by riverciao on 2017/12/8.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import UIKit

class ArticlesTableViewController: UITableViewController {

    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: cellId)
        
        //add addANewArticle navigationItem at rightside
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addANewArticle(sender:)))
        
        self.navigationItem.title = "My Journals"
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 5
//        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var articleCell = ArticleTableViewCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as?  ArticleTableViewCell {
            
            cell.titleLabel.text = "1111"
            cell.pictureImageView.image = #imageLiteral(resourceName: "icon_photo")
            
            articleCell = cell
        }
        
        return articleCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 212
    }
    
    
    
    @objc func addANewArticle(sender: UIBarButtonItem) {
        let newPostViewController = NewPostViewController()
//        self.navigationController?.pushViewController(newPostViewController, animated: true)
        let navController = UINavigationController(rootViewController: newPostViewController)
        present(navController, animated: true, completion: nil)
    }


}

