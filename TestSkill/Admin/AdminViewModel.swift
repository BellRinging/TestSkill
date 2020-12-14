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
//            print(games.count)
            let uid = Auth.auth().currentUser!.uid
            for var detail in games{
                detail.owner = uid
                detail.save()
            }
        }
    }
    
    
    func updateGameDetail(){
        self.background.async {
            
            GameDetail.getAllItem().then { details in
                print(details.count)
                for var detail in details{
                    var list = detail.whoWin
                    list.append(contentsOf: detail.whoLose)
                    let unique = Array(Set(list))
                    detail.involvedPlayer = unique
                    detail.save()
                }
            }
        }
    }
    
    
    func setActUser(){
        if player1.count == 1 {
            UserDefaults.standard.save(customObject: player1[0], inKey: UserDefaultsKey.ActAsUser)
            Utility.showAlert(message: "User Set Complete")
        }
    }
    
    func removeActUser(){
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.ActAsUser)
        Utility.showAlert(message: "Remove Complete")
    }
    
    func updateUser(){
        let groupUser = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser)!
        let lines = arrayFromContentsOfFileWithName(fileName: "data")!
        var games : [String:[String:Int]] = [:]
        let users = ["6Wd8FEKKSPPC5wL2rsbk8lZL9qf2","XqZ2t6RE2vhJVV4RzbT0xKbdIzu2","JK6fMTaxQNgURL8Q4LqxKWeRs4G3","8QfQrvQEklaD9tKfksXrbmOaYo53","9coe3B90tgcfCR5hh5j6X4ipHhN2","MvcrtnVbRDYiEnhECT9wtBjSMOD3"]
        
           let usersName = ["Ricky","sugar","倪康","Kenny Yeung","小希","康哥"]
        
        for line in lines {
          
            let abc = line.split(separator: "\t", maxSplits: 7, omittingEmptySubsequences: false)
            var result : [String:Int] = [:]
            var dummyResult : [String:Int] = [:]
            var userIdList: [String] = []
            var players: [String:String] = [:]
            print(abc)
            if abc[1] != "" {
                result[users[0]] = Int(abc[1])!
                dummyResult[users[0]] = 0
                userIdList.append(users[0])
                players[users[0]] = usersName[0]
            }
            if abc[2] != "" {
                result[users[1]] = Int(abc[2])!
                dummyResult[users[1]] = 0
                userIdList.append(users[1])
                players[users[1]] = usersName[1]
            }
            if abc[3] != "" {
                result[users[2]] = Int(abc[3])!
                dummyResult[users[2]] = 0
                userIdList.append(users[2])
                players[users[2]] = usersName[2]
            }
            if abc[4] != "" {
                result[users[3]] = Int(abc[4])!
                dummyResult[users[3]] = 0
                userIdList.append(users[3])
                players[users[3]] = usersName[3]
            }
            if abc[5] != "" {
                result[users[4]] = Int(abc[5])!
                dummyResult[users[4]] = 0
                userIdList.append(users[4])
                players[users[4]] = usersName[4]
            }
            if abc[6] != "" {
                result[users[5]] = Int(abc[6])!
                dummyResult[users[5]] = 0
                userIdList.append(users[5])
                players[users[5]] = usersName[5]
            }
            let date = "\(abc[0])".replacingOccurrences(of: "-", with: "")
            

                    
                    let formatter = DateFormatter()
            let period = "\(date.prefix(6))"
                    let numList = [0,0,0,0]
                    let groupId = "5F08121C-5EA8-424E-8EAA-C10F40D93A2D"
                    let uuid = UUID().uuidString
                    let today = Date(timeIntervalSinceNow: 0)
                    formatter.dateFormat = "yyyyMMddhhmmss"
                    let currentDateTime = formatter.string(from: today)
                    var temp :[Bool] = []
                    for i in userIdList{
                        temp.append(true)
                    }
                    let playersFitler = Dictionary(uniqueKeysWithValues: zip(userIdList,temp))
//                    let gameType = selectedType == 0 ? GameType.mahjong.rawValue: GameType.big2.rawValue
//                    let tempCount = Dictionary(uniqueKeysWithValues: zip(userIdList,[0,0,0,0]))
//                    let uid = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!.id
//
                    let game = Game(
                        id: uuid,
                        groupId: groupId,
                        location: "Ricky's Home",
                        date: date,
                        period : period,
                        result: result ,
                        totalCards: dummyResult,
                        playersFilter :playersFitler,
                        playersMap : players,
                        playersId :userIdList,
                        createDateTime : currentDateTime,
                        detailCount :0 ,
                        flown: 1 ,
                        gameType:"mahjong",
                        doubleCount: dummyResult,
                        tripleCount: dummyResult,
                        quadipleCount: dummyResult,
                        winCount: dummyResult,
                        bonusFlag :  0,
                        bonus :  0,
                        lostStupidCount:  dummyResult,
                        safeGameCount : dummyResult,
                        doubleBecaseLastCount : dummyResult,
                        water: 0,
                        owner: "8QfQrvQEklaD9tKfksXrbmOaYo53"
                    )
            game.save().then { gam in
                print("update Amount ")             
                     
            }
            
                 
            
        }
    }
    
    
    func deleteGame(){
        Game.getAllItem().then { (games)in
            for game in games {
                let date = game.createDateTime.prefix(8)
                if date == "20200606" {
                    game.delete()
                }
            }
        }
    }
        
    
    func arrayFromContentsOfFileWithName(fileName: String) -> [String]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            return nil
        }

        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n")
        } catch {
            return nil
        }
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
       
        GameRecord.getAllItem().then { _ in
            print("finished")
        }
        

    }
    
    func transfer(){
        if player1.count == 0 || player2.count == 0 {
            Utility.showAlert(message: "Please select the player first")
            return
        }
        
        let userA = player1[0].id
        let userB = player2[0].id
        
        let balance = player1[0].yearBalance
        player2[0].yearBalance = balance
        player2[0].save().then { _ in
            print("update balance")
        }
//        let playerListTemp : [String: String] = [:]
        GameDetail.getAllItem().then { (gameDetails) in
            var promiseList : [Promise<GameDetail>] = []
            for detail in gameDetails{
                var obj = detail
                obj.whoWin = detail.whoWin.map { $0 == userA ? userB:$0 }
                obj.whoLose = detail.whoLose.map { $0 == userA ? userB:$0 }
                obj.involvedPlayer = detail.involvedPlayer.map { $0 == userA ? userB:$0 }
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
                
                
                if var dict = game.doubleCount {
                    for (key, value) in dict {
                        if key == userA{
                            dict[userB] = value
                        }else{
                            dict[key] = value
                        }
                    }
                    game.doubleCount = dict
                }
                if var dict = game.tripleCount {
                    for (key, value) in dict {
                        if key == userA{
                            dict[userB] = value
                        }else{
                            dict[key] = value
                        }
                    }
                    game.tripleCount = dict
                }
                if var dict = game.doubleBecaseLastCount {
                    for (key, value) in dict {
                        if key == userA{
                            dict[userB] = value
                        }else{
                            dict[key] = value
                        }
                    }
                    game.doubleBecaseLastCount = dict
                }
                if var dict = game.lostStupidCount {
                    for (key, value) in dict {
                        if key == userA{
                            dict[userB] = value
                        }else{
                            dict[key] = value
                        }
                    }
                    game.lostStupidCount = dict
                }
//                if var dict = game.playersFilter {
//                    for (key, value) in dict {
//                        if key == userA{
//                            dict[userB] = value
//                        }else{
//                            dict[key] = value
//                        }
//                    }
//                    game.playersFilter = dict
//                }
                if var dict = game.safeGameCount {
                    for (key, value) in dict {
                        if key == userA{
                            dict[userB] = value
                        }else{
                            dict[key] = value
                        }
                    }
                    game.safeGameCount = dict
                }
                if var dict = game.quadipleCount {
                    for (key, value) in dict {
                        if key == userA{
                            dict[userB] = value
                        }else{
                            dict[key] = value
                        }
                    }
                    game.quadipleCount = dict
                }
                if var dict = game.totalCards {
                    for (key, value) in dict {
                        if key == userA{
                            dict[userB] = value
                        }else{
                            dict[key] = value
                        }
                    }
                    game.totalCards = dict
                }
                
                if var dict = game.winCount {
                    for (key, value) in dict {
                        if key == userA{
                            dict[userB] = value
                        }else{
                            dict[key] = value
                        }
                    }
                    game.winCount = dict
                }
                
                
                
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
