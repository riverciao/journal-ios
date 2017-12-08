//
//  TabBarItem.swift
//  ChatRoom
//
//  Created by riverciao on 2017/12/3.
//  Copyright © 2017年 riverciao. All rights reserved.
//

// MARK: - TabBarItem

import UIKit

class TabBarItem: UITabBarItem {
    
    // MARK: Property
    
    var itemType: TabBarItemType?
    
    // MARK: Init
    
    init(itemType: TabBarItemType) {
        
        super.init()
        
        self.itemType = itemType
        
        self.title = itemType.title
        
        self.image = itemType.image
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
}
