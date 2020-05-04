import Foundation
import SwiftUI

class AddGameViewModel: ObservableObject {

    @Published var players : [User] = []
    @Published var gameDate = Date()
    @Published var location = "Ricky Home"
    @Published var showCalendar = false
    @Published var showSelectPlayer = false
    @Published var selectedType = 0
    @Binding var closeFlag : Bool
    var userA : Int = 0
    var userB : Int = 0
    
    init(closeFlag : Binding<Bool>){
        self._closeFlag = closeFlag
    }
    
    var recordDate : String = {
       let abc = " "
        return abc
    }()
    
    
    var calenderManager = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(60*60*24*30 * 5 * -1), maximumDate: Date().addingTimeInterval(60*60*24*30), mode: 0)
   

    func getTextFromDate(date: Date!) -> String {
         let formatter = DateFormatter()
         formatter.locale = .current
         formatter.dateFormat = "d-MMM-yyyy"
         return date == nil ? getTextFromDate(date:Date()) : formatter.string(from: date)
     }
    
    
    func addFriend(){
//        guard let userA = userA , let userB = userB else {return}
        print("Add Friend")
//        let playerA = players.filter(<#T##isIncluded: (User) throws -> Bool##(User) throws -> Bool#>)
        players[userA].updateFriend(userId: players[userB].id)
        players[userA].friends.append(players[userB].id)
        players[userB].updateFriend(userId: players[userA].id)
        players[userB].friends.append(players[userA].id)
        Utility.showAlert(message: "They are friend now")
    }
    
    func saveGame(){
        
        
        
        if players.count != 4 {
            Utility.showAlert(message: "Please select the player")
            return
        }
        
        
        for index in 0...3{
            for index2 in 0...3{
                let id2 = players[index2].id
                if !players[index].friends.contains(id2) && index != index2{
                    self.userA = index
                    self.userB = index2
                    Utility.showAlert(message: "\(players[index].userName) and \(players[index2].userName) are not a fds yet, add them as fds?",callBack:addFriend)
                    return
                }
            }
        }
        
        
        
        
        
        if location == "" {
            Utility.showAlert(message: "Please enter the location")
            return
        }
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyyMMdd"
        let dateObj = calenderManager.selectedDate == nil ? Date() : calenderManager.selectedDate!
        let date = formatter.string(from:dateObj)
        formatter.dateFormat = "yyyyMM"
        let period = formatter.string(from:dateObj)
        let numList = [0,0,0,0]
        let userIdList: [String] = players.map{ $0.id}
        let userNameList : [String] = players.map{$0.userName}
        let players = Dictionary(uniqueKeysWithValues: zip(userIdList,userNameList))
        let result : [String:Int] = Dictionary(uniqueKeysWithValues: zip(userIdList,numList))
        let group = UserDefaults.standard.retrieve(object: PlayGroup.self, fromKey: UserDefaultsKey.CurrentGroup) as! PlayGroup
        let groupId = group.id
        let uuid = UUID().uuidString
        let today = Date(timeIntervalSinceNow: 0)
        formatter.dateFormat = "yyyyMMddhhmmss"
        let currentDateTime = formatter.string(from: today)
        var temp :[Bool] = []
        for i in userIdList{
            temp.append(true)
        }
        let playersFitler = Dictionary(uniqueKeysWithValues: zip(userIdList,temp))
        let gameType = selectedType == 0 ? "Mahjong": "Big2"
        let tempCount = Dictionary(uniqueKeysWithValues: zip(userIdList,[0,0,0,0]))
        
        let game = Game(
            id: uuid,
            groupId: groupId,
            location: location,
            date: date,
            period : period,
            result: result ,
            totalCards: tempCount,
            playersFilter :playersFitler,
            playersMap : players,
            playersId :userIdList,
            createDateTime : currentDateTime,
            detailCount :0 ,
            flown: 0 ,
            gameType:gameType,
            doubleCount: tempCount,
            tripleCount: tempCount,
            quadipleCount: tempCount,
            winCount: tempCount,
            bonusFlag :  0,
            bonus :  0,
            lostStupidCount:  tempCount,
            safeGameCount : tempCount,
            doubleBecaseLastCount : tempCount
        )        
        game.save().then { game in
            print("Game Saved \(game.id)")
            NotificationCenter.default.post(name: .updateGame, object: game)
            DispatchQueue.main.async {
                self.closeFlag.toggle()
            }
        }
    }
   
}
