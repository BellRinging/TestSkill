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
    let userName: String
    let imgUrl : String
    var balance : Int
    let order : Int

    
    init(dict : [String:Any]) {
        self.userName = (dict["name"] as? String ?? "")
        self.imgUrl = (dict["imgUrl"] as? String ?? "")
        self.id = (dict["id"] as? String ?? "")
        self.balance = (dict["balance"] as? Int ?? 0)
        self.order = (dict["order"] as? Int ?? 0)
    }
    
}



public struct DisplayBoardForBig2 : Codable  {
    let id : String
    let userName: String
    let imgUrl : String
    var balance : Int
    let order : Int
    let winCount : Int
    let doubleCount : Int
    let tripleCount : Int
    let qurdipleCount : Int
    let doubleBecaseLastCount : Int
    let safeGameCount : Int
    let lostStupidCount : Int
    var totalCards : Int
    
    init(dict : [String:Any]) {
        self.userName = (dict["name"] as? String ?? "")
        self.imgUrl = (dict["imgUrl"] as? String ?? "")
        self.id = (dict["id"] as? String ?? "")
        self.balance = (dict["balance"] as? Int ?? 0)
        self.order = (dict["order"] as? Int ?? 0)
        
        self.winCount = (dict["winCount"] as? Int ?? 0)
        self.doubleCount = (dict["doubleCount"] as? Int ?? 0)
        self.tripleCount = (dict["tripleCount"] as? Int ?? 0)
        self.qurdipleCount = (dict["qurdipleCount"] as? Int ?? 0)
        self.doubleBecaseLastCount = (dict["doubleBecaseLastCount"] as? Int ?? 0)
        self.lostStupidCount = (dict["lostStupidCount"] as? Int ?? 0)
        self.totalCards = (dict["totalCards"] as? Int ?? 0)
        self.safeGameCount = (dict["safeGameCount"] as? Int ?? 0)        
    }
    
}
