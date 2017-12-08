//
//  Article.swift
//  ChatRoom
//
//  Created by riverciao on 2017/11/26.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import Foundation
import Firebase

class Article: NSObject {
    var id: String?
    var author: String?
    var publishDate: String?
    var title: String?
    var content: String?
}

//struct Article {
//    var title: String
//    var content: String
//}

//class Article {
////    let ref = Database.database().reference(fromURL: "https://chatroom-1fd12.firebaseio.com/")
////    var articleRef: DatabaseReference?
//
////    var key: String?
//    var title: String?
//    var content: String?
//    var author: String?
//    var publishDate: NSDate?
////    var isliked: Bool = false
//
//    init(title: String, content: String) {
//        self.title = title
//        self.content = content
//    }
//
////    init(key: String, dictionary: [String: AnyObject]) {
////        self.key = key
////
////        // Within the Joke, or Key, the following properties are children
////
////        if let title = dictionary["title"] as? String {
////            self.title = title
////        }
////
////        if let content = dictionary["content"] as? String {
////            self.content = content
////        }
////
////        if let author = dictionary["author"] as? String {
////            self.author = author
////        }
////
////        if let publishDate = dictionary["publishDate"] as? NSDate {
////            self.publishDate = publishDate
////        }
//
//
//        // The above properties are assigned to their key.
//
////        self.articleRef = ref.child("posts").child(key)
////    }
//
//}

