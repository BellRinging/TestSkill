//
//  Post.swift
//  SnookerGambling
//
//  Created by Kwok Wai Yeung on 30/6/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit

struct Comment {
    
    var id: String?
    
    let user: User
    let comment : String
    let creationDate: Date
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.comment = dictionary["text"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}

