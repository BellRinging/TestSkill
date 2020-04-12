//
//  TestFontViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 2/2/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import Promises


class TestFontViewModel : ObservableObject{
    
    
    lazy var background: DispatchQueue = {
          return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
      }()
    
    
    init(){
        
    }
    
        func createGroupObject(users: [User]) -> PlayGroup{
            //Create group
            let uuid = UUID().uuidString
            let rule = [3:60,4:130,5:190,6:260,7:380,8:510,9:770,10:1020
                                ,30:30,40:60,50:100,60:130,70:190,80:260,90:380,100:510]
    
            let players = users.map { $0.id}
            let playersName = users.map{$0.userName ?? ""}
            var group = PlayGroup()
            group.id = uuid
            group.players = players
            group.playersName = playersName
            group.rule = rule
            group.groupName = "VietNam"
            return group
        }
            
            
    func deleteGroup(){
        self.background.async {
            
            
            PlayGroup.getAllItem().then{ groups in
                for group in groups {
                    group.delete()
                }
            }.catch{err in
                print(err.localizedDescription)
            }
            
            
        }
    }
            
    
    func DeleteGame(){
           self.background.async {
               
               
               Game.getAllItem().then{ games in
                   for game in games {
                        game.delete()
                   }
               }.catch{err in
                   print(err.localizedDescription)
               }
//
               GameDetail.getAllItem().then{ gameDetails in
                   for gameDetail in gameDetails {
                    gameDetail.delete()
                   }
               }.catch{err in
                   print(err.localizedDescription)
               }
//
            
            User.getAllItem().then{ users in
                for user in users {
//                    user.updateBalance(value: 0)
                    GameRecord.getAllItem(userId: user.id).then { (gameRecords)in
                        for gameRecord in gameRecords {
                            gameRecord.delete(userId: user.id)
                        }
                    }
                }
            }.catch{err in
                print(err.localizedDescription)
            }
            
           }
       }
    
    
    func deleteUserRecords(){
         self.background.async {
             User.getAllItem().then{ users in
                 for user in users {
                     user.updateBalance(value: 0)
                     GameRecord.getAllItem(userId: user.id).then { (gameRecords)in
                         for gameRecord in gameRecords {
                             gameRecord.delete(userId: user.id)
                         }
                     }
                 }
             }.catch{err in
                 print(err.localizedDescription)
             }
                
        }
        
    }
    
    
       func deleteUserBalanceAndItem(){
            self.background.async {
                User.getAllItem().then{ users in
                    for user in users {
                        user.updateBalance(value: 0)
                        GameRecord.getAllItem(userId: user.id).then { (gameRecords)in
                            for gameRecord in gameRecords {
                                gameRecord.delete(userId: user.id)
                            }
                        }
                    }
                }.catch{err in
                    print(err.localizedDescription)
                }
                   
           }
           
       }
    
      func deleteGameDetail(){
         self.background.async {
 
                       GameDetail.getAllItem().then{ gameDetails in
                           for gameDetail in gameDetails {
                            gameDetail.delete()
                           }
                       }.catch{err in
                           print(err.localizedDescription)
                       }
        }
        
    }
    
    func addGame(){
        background.async {
            
            let users = try! await(User.getAllItem())
            let abc = self.createGroupObject(users: users)
            abc.save().then{ group in
                print("completed")
            }
        }
    }
    
//
//       func handleAddGame(){
//    
////                Utility.showProgress()
//    
//    
//            self.background.async {
//
//                PlayGroup.getById(id: "4D59E86B-B0A0-41FE-A21F-FDC57DF47B4C").then { (group) in
//                    print("Get the group")
//                    self.background.async {
//                        var users : [User] = []
//                        for key in group.players {
//                            let user = try! await(User.getById(id: key))
//                            users.append(user!)
//                        }
//                        let groupRule = group.rule
//                        for round in 0...8{
//                            print("round : \(round)")
//                            let game = self.createRandomGame(users: users, group: group)
//                            print(game)
//                            let _ =  game.save().then{ game in
//                                print("Save Game \(round)")
////                                for _ in 0...8{
////                                    let gameDetail = self.createGameDetailObject(game: game, groupRule: groupRule)
////                                    self.saveGameDetail(gameDetail: gameDetail, game: game, users: users)
////                                }
//                            }
//                        }
//                    }
//                }
//        }
//    
//    }
    
//     func createGameDetailObject(game : Game, groupRule : [Int:Int]) ->GameDetail{
//
//            let whoWin = game.result.randomElement()!
//            let randomWinType = ["self","other"].randomElement()!
//            var value = 0
//            let fanNo = Int.random(in: 3...10)
//            var whoLoseList:[String] = []
//
//            if (randomWinType == "other"){
//                value = groupRule[fanNo]!
//                var whoLose = whoWin
//                while ( whoWin.key == whoLose.key ){
//                    whoLose = game.result.randomElement()!
//                }
//                whoLoseList = [whoLose.key]
//            }else{
//                value = groupRule[fanNo * 10]!
//                whoLoseList = game.result.keys.filter{ $0 != whoWin.key}
//            }
//            let uuid = UUID().uuidString
//        let gameDetail = GameDetail(gameDetailId: uuid, gameId: game.id, remark: "\(fanNo) fan", value: value, whoLose: whoLoseList, whoWin: whoWinList, winType: win, byErrorFlag: <#T##Int#>
//
//                gameDetailId: uuid, gameId: game.id, remark: "\(fanNo) fan", value: value, whoLose: whoLoseList, whoWin: [whoWin.key], winType: randomWinType)
//            return gameDetail
//        }


        func saveGameDetail(gameDetail :GameDetail ,game : Game ,users:[User]){
            let _ =  gameDetail.save().then{ detail in
//                self.saveIndivualRecord(detail: detail, game: game, users: users)
            }.catch{ err in
//                Utility.showAlert(self, message: err.localizedDescription)
                print(err.localizedDescription)
            }
        }
    
    
        func getAllUser() -> [User]{
           // get all users
            let users = try! await(User.getAllItem().catch{ err in
                Utility.showAlert( message: err.localizedDescription)
                print(err.localizedDescription)
                }
            )
            return users
        }
    
       
       
//           func createRandomGame(users : [User] , group : PlayGroup) -> Game{
//               let someDateTime = self.generateRandomDate(daysBack:365)
//               let dateFormatter = DateFormatter()
//               dateFormatter.dateFormat = "yyyyMMdd"
//               let date = dateFormatter.string(from: someDateTime!)
//               dateFormatter.dateFormat = "yyyyMM"
//               let period = dateFormatter.string(from: someDateTime!)
//               let numList = [0,0,0,0]
//               let location = ["CP Home", "Ricky Home"]
//               let area = location.randomElement()!
//               let randomPickList = self.randomPick(array: users, number: 4) as! [User]
//               let userIdList: [String] = randomPickList.map{ $0.id}
//               let userNameList : [String] = randomPickList.map{$0.userName!}
//               let players = Dictionary(uniqueKeysWithValues: zip(userIdList,userNameList))
//               let result : [String:Int] = Dictionary(uniqueKeysWithValues: zip(userIdList,numList))
//               let groupId = group.id
//               let uuid = UUID().uuidString
//               let today = Date(timeIntervalSinceNow: 0)
//               dateFormatter.dateFormat = "yyyyMMddhhmmss"
//               let currentDateTime = dateFormatter.string(from: today)
//            let playersFilter : [String:Bool] = [:]
//            let game = Game(id: uuid, groupId: groupId, location: area, date: date, period : period, result: result,playersFilter:playersFilter ,playersMap : players,playersId :userIdList,createDateTime : currentDateTime)
//               return game
//           }
       
           func generateRandomDate(daysBack: Int)-> Date?{
               let day = arc4random_uniform(UInt32(daysBack))+1
               let hour = arc4random_uniform(23)
               let minute = arc4random_uniform(59)
               let today = Date(timeIntervalSinceNow: 0)
               let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
               var offsetComponents = DateComponents()
               offsetComponents.day = -1 * Int(day - 1)
               offsetComponents.hour = -1 * Int(hour)
               offsetComponents.minute = -1 * Int(minute)
               let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
               print("end of create random date")
               return randomDate
           }
       
           func randomPick(array:[Any],number : Int)-> [Any]{
               let count = Int(array.count) - 1
               var result : [Any] = []
               var used : [Int] = []
               var random : Int = 0
               for _ in 1...number{
                   random = Int.random(in: 0...count)
                   while  used.firstIndex(of: random) != nil {
                       random = Int.random(in: 0...count)
                   }
                   result.append(array[random])
                   used.append(random)
               }
               return result
           }
    
}
