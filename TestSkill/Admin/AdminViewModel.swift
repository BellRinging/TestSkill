//
//  SearchViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 18/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import Firebase
import Promises

class AdminViewModel: ObservableObject {
    
    @Published var isShowGameLK: Bool = false
    @Published var gameTemp : Game?
    @Published var player1 : [User] = []
    @Published var player2 : [User] = []
    @Published var isShowPlayer1: Bool = false
    @Published var isShowPlayer2: Bool = false
    init() {
//        initPeriod()
//        initFan()
    }
    
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
        
    
    func updateGame(){
        Game.getAllItem().then { games in
            print(games.count)
            for var detail in games{
                detail.water = 0
                detail.save()
            }
        }
    }
    
    
    func updateGameDetail(){
        self.background.async {
            
            GameDetail.getAllItem().then { details in
                print(details.count)
                for var detail in details{
                    detail.waterFlag = 0
                    detail.waterAmount = 0
                    detail.save()
                }
            }
        }
    }
    func DeleteGame(){
 
        let id = gameTemp!.id
        GameDetail.getAllItemById(gameId: id).then{ details in
              
            for detail in details{
//                print("detail: \(detail.id)")
                detail.delete()
            }
        }.catch{err in
            print(err.localizedDescription)
        }
      
        GameRecord.getAllByGameId(gameId: id).then{ records in
            for record in records{
//                record.
            }
        }.catch { (err) in
            print(err)
        }
        gameTemp?.delete()
    }
    
    func unFlownGame(){
        if gameTemp == nil {
            Utility.showAlert(message: "No game selected")
            return
        }
        Game.getItemById(gameId: gameTemp!.id).then { (game)in
            return game.markFlown(flown: 0)
        }.then { game in
            Utility.showAlert(message: "Completed")
        }.catch { (err) in
            Utility.showAlert(message: err.localizedDescription)
        }
    }
    
    func UpdateId(){
       
        GameRecord.getAllItemAndFixthePath().then{ records in
            print(records.count)
//            for record in records{
//                print("\(record.userId) -> \(record.id)")
//                record.save()
//            }
            
        }
        
//        User.getAllItem().then{ users in
//
//            let db = Firestore.firestore()
//            var dict : [String:[GameRecord]] = [:]
//            self.background.async {
//
//                for user in users {
//                    print("User :\(user.id)")
//                    let gamesRecords = try! await(GameRecord.getById2(userId: user.id))
//                    if gamesRecords.count > 0 {
//                        for record in gamesRecords{
//                            let _ = try! await (record.updateId(userId:user.id))
//                        }
//                    }
//
//                }
//            }
//        }
        
    }
    
    func transfer(){
        if player1.count == 0 || player2.count == 0 {
            Utility.showAlert(message: "Please select the player first")
            return
        }
        
        let userA = player1[0].id
//        let userA = "r9qA0orWkqWntJTXo4AMkMrIXIC3"
//        let userB = "XqZ2t6RE2vhJVV4RzbT0xKbdIzu2"
        let userB = player2[0].id

        GameDetail.getAllItem().then { (gameDetails) in
            var promiseList : [Promise<GameDetail>] = []
            for detail in gameDetails{
                var obj = detail
                obj.whoWin = detail.whoWin.map { $0 == userA ? userB:$0 }
                obj.whoLose = detail.whoLose.map { $0 == userA ? userB:$0 }
                var dict : [String: String] = [:]
                for (key, value) in detail.playerList{
                    if key == userA{
                        dict[userB] = value
                    }else{
                        dict[key] = value
                    }
                }
                obj.playerList = dict
                promiseList.append(obj.save())
            }
            Promises.all(promiseList).then{ _ in
                print("finish trandfer gameDetail")
            }
        }
        
        GameRecord.getById2(userId: userA).then { (details)in
            var promiseList : [Promise<GameRecord>] = []
            for var detail in details {
                detail.userId = userB
                promiseList.append(detail.save())
            }
            Promises.all(promiseList).then{ _ in
                print("finish trandfer user GameRecord")
            }
        }
        
        GameRecord.getAllByTo(userId: userA).then{records in
            var promiseList : [Promise<GameRecord>] = []
            for var detail in records {
                if (detail.to == userA) {
                    detail.to = userB
                    promiseList.append(detail.save())
                }
                print(detail)
            }
            Promises.all(promiseList).then{ _ in
                print("finish trandfer to GameRecord")
            }
        }
        
//
        Game.getAllItem().then{games in
            var promiseList : [Promise<Game>] = []
            for var game in games{
                var dict : [String: String] = [:]
                for (key, value) in game.playersMap{
                    if key == userA{
                        dict[userB] = value
                    }else{
                        dict[key] = value
                    }
                }
                game.playersMap = dict
                var dict2 : [String: Int] = [:]
                for (key, value) in game.result{
                    if key == userA{
                        dict2[userB] = value
                    }else{
                        dict2[key] = value
                    }
                }
                game.result = dict2
                var dict3 : [String: Bool] = [:]
                for (key, value) in game.playersFilter{
                    if key == userA{
                        dict3[userB] = value
                    }else{
                        dict3[key] = value
                    }
                }
                game.playersFilter = dict3
                var list : [String] = []
                for player in game.playersId{
                    if player == userA{
                        list.append(userB)
                    }else{
                        list.append(player)
                    }
                }
                game.playersId = list
                promiseList.append(game.save())
            }
            Promises.all(promiseList).then{ _ in
                print("finish trandfer Game")
            }
        }
    }
}
