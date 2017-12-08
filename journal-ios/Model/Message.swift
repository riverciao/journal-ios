//
//  Message.swift
//  ChatRoom
//
//  Created by riverciao on 2017/12/4.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import Firebase

struct Message {
    var fromId: String?
    var toId: String?
    var text: String?
    var timestamp: Int?
    
    func getChatPartnerId() -> String? {
        if fromId == Auth.auth().currentUser?.uid {
            return toId
        } else {
            return fromId
        }
    }
}
