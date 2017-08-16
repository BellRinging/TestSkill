//
//  Page.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 10/8/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import Foundation

struct Page {
    let title : String
    let massage : String
    let image : String
    
    
    init(title: String, image : String,massage:String) {
        self.title = title
        self.massage = massage
        self.image = image
        
    }
}
