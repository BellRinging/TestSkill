//
//  Post.swift
//  SnookerGambling
//
//  Created by Kwok Wai Yeung on 30/6/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Post {
    
    var likeCount : Int?
    
    var id: String? {
        didSet{
            guard let key = id else {return}
            let ref = Database.database().reference().child("likes").child(key)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? [String: Any]{
                    self.likeCount = value.count
                    //                    print("like count \(self.likeCount) for post \(self.caption)" )
                }else {
                    self.likeCount = 0
                }
            })
        }
    }
    
    let user: User
    let imageUrl: String
    let caption: String
    let creationDate: Date
    
    var hasLiked = false
    
    init(user: User, dictionary: [String: Any]) {
        self.likeCount = 1
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
