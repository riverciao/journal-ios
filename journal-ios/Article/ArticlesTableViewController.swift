//
//  ArticlesTableViewController.swift
//  ChatRoom
//
//  Created by riverciao on 2017/11/24.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import UIKit
import Firebase
import CoreData


class ArticlesTableViewController: UITableViewController {
    
    var items: [Item] = []
    var currentItem: Item?
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: cellId)
        
        //hide nav bar but show button
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //add addANewArticle navigationItem at rightside
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addANewArticle(sender:)))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationTitleView()
        
        //change navigation bar item color to dustyOrange
        self.navigationController?.navigationBar.tintColor = UIColor(r: 237, g: 96, b: 81)
        
        items = CoreDataHandler.fetchObject()!
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editPostViewController = EditPostViewController()
        self.currentItem = items[indexPath.row]
        editPostViewController.currentItem = self.currentItem
        self.navigationController?.pushViewController(editPostViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataHandler.deleteObject(item: items[indexPath.row])
            self.items = CoreDataHandler.fetchObject()!
            self.tableView.reloadData()
        }
    }
    
    private func setupNavigationTitleView() {
        let label = UILabel(frame: CGRect(x: 30, y: 0, width: 283, height: 24))
        
        label.text = "My Journals"
        label.textAlignment = .left
        label.textColor = UIColor(r: 67, g: 87, b: 97)
        label.font =  UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        self.navigationItem.titleView = label
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    @objc func addANewArticle(sender: UIBarButtonItem) {
        let postViewController = PostViewController()
        self.navigationController?.pushViewController(postViewController, animated: true)
    }

    
}


    

    


