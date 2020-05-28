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
    
    
    init(game:Game ) {
        self.game = game
    }
    
    var users:[User] = []
    var game : Game
    
    func initial(){
        location = game.location
        let tempDate = game.date
        date = "\(tempDate.suffix(2))/\(tempDate.prefix(6).suffix(2))/\(tempDate.prefix(4))"
        let uid = Auth.auth().currentUser?.uid
        otherPlayers = []
        otherPlayersResult = []
        let _ = game.result.map { (key,value) in
            if key == uid {
                amount = value
                win = amount > 0 ? true : false
            }else{
                otherPlayersResult.append(value > 0 ? true : false)
                if let groupUser = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser){
                    let user = groupUser.filter{$0.id == key}.first!
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
