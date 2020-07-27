//
//  GamePassingObject.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 27/7/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation


struct GameList {
    var list : [GamePassingObject] = []
    
    mutating func updateGame(game: Game){
        let period = game.period
        let index = list.firstIndex { $0.id ==  period}
        if index != nil && list.count > 0 {
            let gameList = self.list[index!].games
            let index2 = gameList.firstIndex { $0.id == game.id }
            if  index2 != nil {
                self.list[index!].updateGame(game:game,index:index2!)
            }
        }else{
            let uid =  UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!.id
            let temp = GamePassingObject(id: period , games : [game] , periodAmt : game.result[uid] ?? 0)
            list.append(temp)
        }
    }
    
    mutating func addGamePassingObject(gameObj :GamePassingObject){
        list.append(gameObj)
    }
}

struct GamePassingObject : Identifiable{
    
    var id : String
    var games : [Game] = []
    var periodAmt : Int
    
    mutating func updateGame(game: Game , index : Int){
        self.games[index] = game
    }
}
