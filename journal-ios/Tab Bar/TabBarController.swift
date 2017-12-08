//
//  TabBarController.swift
//  ChatRoom
//
//  Created by riverciao on 2017/12/3.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: Init
    
    init(itemTypes: [TabBarItemType]) {
        
        super.init(nibName: nil, bundle: nil)
        
        let viewControllers: [UIViewController] = itemTypes.map(
            
            TabBarController.prepare
            
        )
        
        setViewControllers(viewControllers, animated: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        
    }
    
    private func setupTabBar() {
        
        tabBar.barStyle = .default
        
        tabBar.isTranslucent = false
        
        tabBar.tintColor = UIColor(
            red: 53.0 / 255.0,
            green: 184.0 / 255.0,
            blue: 208 / 255.0,
            alpha: 1.0
        )
        
    }
    
    // MARK: Prepare Item Type
    
    static func prepare(for itemType: TabBarItemType) -> UIViewController {
        
        switch itemType {
            
        case .blog:
            
            let articlesTableViewController = ArticlesTableViewController(style: .plain)
            
            let navigationController = UINavigationController(
                
                rootViewController: articlesTableViewController
                
            )
            
            navigationController.tabBarItem = TabBarItem(
                itemType: itemType
            )
            
            return navigationController
            
        case .chat:
            
            let chatTableViewController = ChatTableViewController()
            
            let navigationController = UINavigationController(
                
                rootViewController: chatTableViewController
                
            )
            
            navigationController.tabBarItem = TabBarItem(itemType: itemType)
            
            return navigationController
        }
        
    }

}
