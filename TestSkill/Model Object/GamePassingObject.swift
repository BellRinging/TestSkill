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
    var noMoreGame: Bool = false
    var startAgain: Bool = false
    
    mutating func updateGame(game: Game){
        let period = game.period
        let index = list.firstIndex { $0.id ==  period}
        
        if index != nil && list.count > 0 {
            let gameList = self.list[index!].games
            let index2 = gameList.firstIndex { $0.id == game.id }
//            print("game is in the list index:",index2)
            if  index2 != nil {
                self.list[index!].updateGame(game:game,index:index2!)
            }else{
                // add new
                self.list[index!].addNewGame(game: game)
            }
        }else{
            print("game is not in the list")
            let uid =  UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!.id
            let temp = GamePassingObject(id: period , games : [game] , periodAmt : game.result[uid] ?? 0)
            list.insert(temp, at: 0)
        }
    }
    
    mutating func addGamePassingObject(gameObj :GamePassingObject){
        list.append(gameObj)
    }
    
    mutating func deleteGame(game :Game){
        let period = game.period
        let index = list.firstIndex { $0.id ==  period}!
        let gameObj = self.list[index]
        
        if gameObj.games.count == 1{
            self.list.remove(at: index)
        }else{
            let gameList = gameObj.games
            let index2 = gameList.firstIndex { $0.id == game.id }!
            self.list[index].deleteGame(index: index2)
        }
        
    }
}

struct GamePassingObject : Identifiable {
    
    var id : String
    var games : [Game] = []
    var periodAmt : Int
    
    mutating func updateGame(game: Game , index : Int){
        self.games[index] = game
//        print("after game:",self.games[index].result)
    }
    
    mutating func addNewGame(game: Game ){
        var list = self.games
        list.append(game)
        list = list.sorted{$0.date > $1.date}
        self.games = list
    }
    
    mutating func deleteGame(index : Int){
        self.games.remove(at: index)
    }
}
