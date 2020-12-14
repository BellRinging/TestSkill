//
//  FlownGameViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import SwiftUI


class MarkFlownViewModel : ObservableObject {

    @Published var game : Game
    @Binding var closeFlag : Bool
    @Published var players : [User] = []
    @Published var playersAmtInString : [String] = ["0","0","0","0"]{
        didSet{
            self.changeBalance()
        }
    }
    @Published var showAlert : Bool = false
    var playersAmt : [Int] = [0,0,0,0]
    @Published var balanceLeft : Int = 0
    
    init(closeFlag : Binding<Bool>,game : Game){
        self._closeFlag = closeFlag
        self.game = game
        if let userInGroup = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser){
            for i in 0...3{
                let playerId = game.playersId[i]
                let player  = userInGroup.filter{$0.id == playerId}.first!
                self.players.append(player)
                self.playersAmtInString[i] = "\(game.result[playerId]!)"
                self.playersAmt[i] = game.result[playerId]!
            }
        }
    }
    
    func changeBalance(){
        self.balanceLeft = playersAmtInString.reduce(0){ oldValue ,newValue in
            oldValue + (Int(newValue) ?? 0)
        }
    }
    
    
    func confirm(){
        print("update Amount ")
        for i in 0...3{
            if playersAmtInString[i] == "" {
                Utility.showAlert(message: "please enter the value")
                return
            }
        }
        var user = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
        var diff : [Int] = [0,0,0,0]
        var result : [String:Int] = [:]
        for i in 0...3{
            result[players[i].id] = Int(playersAmtInString[i])!
            diff[i] = Int(playersAmtInString[i] )! - playersAmt[i]
            let year = Int(game.period.prefix(4))!
            if players[i].id == user.id {
                user.yearBalance[year] = (user.yearBalance[year] ?? 0) + diff[i]
                 UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
            }
            if diff[i] != 0 {
                let _ = game.updateResult(playerId: players[i].id ,value: diff[i])
                let _ = players[i].updateBalance(value: diff[i],year: year)
            }
        }
        let _ = game.markFlown()
        game.result = result
        game.flown = 1
        game.water = 0
        NotificationCenter.default.post(name: .updateGame, object: game)
        closeFlag.toggle()
        
    }
}
