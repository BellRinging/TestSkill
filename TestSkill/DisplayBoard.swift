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
    let user_name: String
    let img_url : String
    var balance : Int
    let order : Int
    
    init(dict : [String:Any]) {
        self.user_name = (dict["name"] as? String ?? "")
        self.img_url = (dict["imgUrl"] as? String ?? "")
        self.id = (dict["id"] as? String ?? "")
        self.balance = (dict["balance"] as? Int ?? 0)
        self.order = (dict["order"] as? Int ?? 0)
    }
    
}
