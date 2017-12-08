//
//  TabBarItemType.swift
//  ChatRoom
//
//  Created by riverciao on 2017/12/3.
//  Copyright © 2017年 riverciao. All rights reserved.
//

// MARK: - TabBarItemType

import UIKit

enum TabBarItemType {
    case blog, chat
}

// MARK: - Title

extension TabBarItemType {
    
    var title: String {
        
        switch self {
            
        case .blog:
            
            return NSLocalizedString("Blog", comment: "")
            
        case .chat:
            
            return NSLocalizedString("Chat", comment: "")
            
        }
        
    }
    
}


// MARK: - Image

extension TabBarItemType {
    
    var image: UIImage {
        
        switch self {
            
        case .blog:
            
            return #imageLiteral(resourceName: "icon-blog").withRenderingMode(.alwaysTemplate)
            
        case .chat:
            
            return #imageLiteral(resourceName: "icon-chat").withRenderingMode(.alwaysTemplate)
        }
        
    }
    
}


