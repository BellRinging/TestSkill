////
////  ChatDetailViewModel.swift
////  QBChat-MVVM
////
////  Created by Paul Kraft on 30.10.19.
////  Copyright © 2019 QuickBird Studios. All rights reserved.
////
//
import Foundation
import Combine
import FirebaseAuth
import Promises
//
//
class GameRowViewModel: ObservableObject {
    
    
    init(game:Game ,users:[User]) {
        self.game = game
        self.users = users
    }
    
    var users:[User] = []
    var game : Game
    
    func initial(){
//        print("initial game row")
        location = game.location
        let tempDate = game.date
        date = "\(tempDate.suffix(2))/\(tempDate.prefix(6).suffix(2))/\(tempDate.prefix(4))"
        let uid = Auth.auth().currentUser?.uid
        otherPlayers = []
        otherPlayersResult = []
        game.result.map { (key,value) in
            if key == uid {
                amount = value
                win = amount > 0 ? true : false
            }else{
                otherPlayersResult.append(value > 0 ? true : false)
                User.getById(id: key).then{ user in
                    guard let user = user else {return}
                    self.otherPlayers.append(user)
                }
            }
        }
    }
    
    var date : String = ""
    var location : String = ""
    @Published var otherPlayers : [User] = []
    @Published var otherPlayersResult : [Bool] = []
    var win : Bool = false
    var amount : Int = 0
   
}
