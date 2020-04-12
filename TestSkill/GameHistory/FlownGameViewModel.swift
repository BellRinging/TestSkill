//
//  FlownGameViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import SwiftUI


class FlownGameViewModel : ObservableObject {

    @Published var game : Game
    @Binding var closeFlag : Bool
    @Published var player1 : User?
    @Published var player2 : User?
    @Published var player3 : User?
    @Published var player4 : User?
    @Published var player1Amt : String = ""
    var player1OAmt : Int = 0
    var player2OAmt : Int = 0
    var player3OAmt : Int = 0
    var player4OAmt : Int = 0
    @Published var player2Amt : String = ""
    @Published var player3Amt : String = ""
    @Published var player4Amt : String = ""
    @Published var showAlert : Bool = false
    
    init(closeFlag : Binding<Bool>,game : Game){
        self._closeFlag = closeFlag
        self.game = game
        
        print("inside flown game")
        if let userInGroup = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser){
            self.player1Amt = "\(game.result[game.playersId[0]]!)"
            self.player2Amt = "\(game.result[game.playersId[1]]!)"
            self.player3Amt = "\(game.result[game.playersId[2]]!)"
            self.player4Amt = "\(game.result[game.playersId[3]]!)"
            self.player1OAmt = Int(game.result[game.playersId[0]]!)
            self.player2OAmt = Int(game.result[game.playersId[1]]!)
            self.player3OAmt = Int(game.result[game.playersId[2]]!)
            self.player4OAmt = Int(game.result[game.playersId[3]]!)
            player1 = userInGroup.filter{$0.id == game.playersId[0]}.first!
            player2 = userInGroup.filter{$0.id == game.playersId[1]}.first!
            player3 = userInGroup.filter{$0.id == game.playersId[2]}.first!
            player4 = userInGroup.filter{$0.id == game.playersId[3]}.first!
        }
    }
    
    
    func confirm(){
        
        if (
            player1Amt == "" ||
            player2Amt == "" ||
            player3Amt == "" ||
            player4Amt == ""
            ){
            Utility.showAlert(message: "please enter the value")
            return 
        }
        
        
        print("update Amount ")
        
        let diff1 = Int(player1Amt)! - player1OAmt
        let diff2 = Int(player2Amt)! - player2OAmt
        let diff3 = Int(player3Amt)! - player3OAmt
        let diff4 = Int(player4Amt)! - player4OAmt
        
        print(diff1)
        print(diff2)
        print(diff3)
        print(diff4)
        
        if diff1 != 0 {
            game.updateResult(playerId: player1!.id ,value: (diff1))
            player1?.updateBalance(value: diff1)
            print("\(player1!.userName) : \(diff1)")
        }
        if diff2 != 0 {
            game.updateResult(playerId: player2!.id ,value: (diff2))
            player2?.updateBalance(value: diff2)
            print("\(player2!.userName) : \(diff2)")
        }
        if diff3 != 0 {
            game.updateResult(playerId: player3!.id ,value: (diff3))
            player3?.updateBalance(value: diff3)
            print("\(player3!.userName) : \(diff3)")
        }
        if diff4 != 0 {
            game.updateResult(playerId: player4!.id ,value: (diff4))
            player4?.updateBalance(value: diff4)
            print("\(player4!.userName) : \(diff4)")
        }
        game.markFlown()
        
        game.result = [
            "\(player1!.id)":Int(player1Amt) ?? 0,
            "\(player2!.id)":Int(player2Amt) ?? 0,
            "\(player3!.id)":Int(player3Amt) ?? 0,
            "\(player4!.id)":Int(player4Amt) ?? 0,
        ]
        game.flown = 1
        NotificationCenter.default.post(name: .updateGame, object: game)
        var user = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
        if player1!.id == user.id {
            user.balance  = user.balance + diff1
            UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
        }
        if player2!.id == user.id {
            user.balance  = user.balance + diff2
            UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
        }
        if player3!.id == user.id {
            user.balance  = user.balance + diff3
            UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
        }
        if player4!.id == user.id {
            user.balance  = user.balance + diff4
            UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
        }
        closeFlag.toggle()
        
    }
}
