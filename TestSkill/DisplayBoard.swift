//
//  DisplayBoard.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 30/12/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import Foundation


public struct DisplayBoard : Codable  {
    let id : String
    let user_id : String
    let user_name: String
    let img_url : String
    var balance : Int
    
    init(dict : [String:String]) {
        self.user_id = dict["user_id"] ?? ""
        self.user_name = dict["user_name"] ?? ""
        self.img_url = dict["image_url"] ?? ""
        self.id = dict["id"] ?? ""
        self.balance = 0
    }
    
}
