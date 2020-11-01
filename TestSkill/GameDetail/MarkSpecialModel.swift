//
//  FlownGameViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import FirebaseAuth
import SwiftUI


class MarkSpecialViewModel : ObservableObject {

    
    @Binding var closeFlag : Bool
    @Published var players : [User] = []
    @Published var playersAmt : [Int] = [0,0,0,0]
    @Published var playersOffset : [Int] = [0,0,0,0]
    
    var lose1xPosition : Int = -30
    var win1xPosition : Int = 0
    var win2xPosition : Int = 30
    @Binding var game : Game
    @Binding var lastGame : GameDetail?
    var hasLoser : Bool = false
    var group : PlayGroup?
    var specialItemAmt : Int = 50
    
    
    init(closeFlag : Binding<Bool>,game : Binding<Game> , lastGame : Binding<GameDetail?>){
        self._closeFlag = closeFlag
        self._game = game
        self._lastGame = lastGame
        print("init Special")
        if let userInGroup = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser){
            for playerId in game.wrappedValue.playersId {
                let player = userInGroup.filter{$0.id == playerId}.first!
                self.players.append(player)
            }
        }
        if let group = UserDefaults.standard.retrieve(object: PlayGroup.self, fromKey: UserDefaultsKey.CurrentGroup){
            self.group = group
            self.specialItemAmt = group.specialItemAmount
        }
    }
    
    
    func updatePosition(playerIndex : Int ){
        if playersOffset[playerIndex] == win1xPosition {
            playersOffset[playerIndex] = !hasLoser ? lose1xPosition : win2xPosition
            
            if playersOffset[playerIndex] == lose1xPosition{
                hasLoser = true
            }
        }else if playersOffset[playerIndex] == win2xPosition {
            playersOffset[playerIndex] = !hasLoser ? lose1xPosition : win1xPosition
            
            if playersOffset[playerIndex] == lose1xPosition{
                hasLoser = true
            }
        }else if playersOffset[playerIndex] == lose1xPosition {
            playersOffset[playerIndex] = win1xPosition
            hasLoser = false
        }
        updateLabel()
        
    }
 
    func updateLabel(){
        
        //winner amount
        var totalAmount : Int = 0
        for i in 0...3 {
            if (self.playersOffset[i] >= win1xPosition ){
                self.playersAmt[i] = playersOffset[i] == win1xPosition ? specialItemAmt : specialItemAmt*2
                totalAmount = totalAmount + self.playersAmt[i]
            }
        }
//        print("total \(totalAmount)")
        //loser amount
        for i in 0...3 {
            if (self.playersOffset[i] == lose1xPosition ){
                self.playersAmt[i] =  totalAmount * -1
                break
            }
        }
    }
    
    

    func markSpecial(){
        let uid = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!.id
        if uid != self.game.owner{
            Utility.showAlert(message: "Only Owner can mark record")
            return
        }
        
        print(hasLoser)
        if (!hasLoser){
            Utility.showAlert(message: "Not valid setting")
            return
        }
        
        Utility.showProgress()
        let detailNo = game.detailCount + 1
        var whoLoseList:[String] = []
        var whoWinList:[String] = []
        var winnerAmount = 0
        var loserAmount = 0
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let datetime = formatter.string(from: Date())
        let playersList = self.game.playersMap
        let period = self.game.period
        var involvedPlayer = whoLoseList
        involvedPlayer.append(contentsOf: whoWinList)
        involvedPlayer = Array(Set(involvedPlayer))
    
        for i in 0...3 {
            if (self.playersOffset[i] >= win1xPosition ){
                whoWinList.append(self.players[i].id)
                if (self.playersOffset[i] == win2xPosition ){
                    whoWinList.append(self.players[i].id)
                }
            }else{
                whoLoseList.append(self.players[i].id)
            }
        }
        winnerAmount = self.specialItemAmt
        loserAmount = self.playersAmt.filter{$0 < 0}.first!
        let uuid = UUID().uuidString
        let gameDetail = GameDetail(id: uuid,
                                    gameId: self.game.id,
                                    fan: 0,
                                    value: winnerAmount,
                                    winnerAmount: winnerAmount,
                                    loserAmount: loserAmount,
                                    whoLose: whoLoseList,
                                    whoWin: whoWinList,
                                    winType: "Special" ,
                                    byErrorFlag: 0,
                                    repondToLose:0,
                                    playerList:playersList,
                                    involvedPlayer: involvedPlayer,
                                    period:period,
                                    createDateTime:datetime,
                                    detailNo: detailNo,
                                    bonusFlag: 0,
                                    bonus: 0,
                                    waterFlag: 0,
                                    waterAmount: 0)
        gameDetail.save().then { (gameDetail)  in
            
            let uid = Auth.auth().currentUser!.uid
            var updateAmount = 0
            var tempGame = self.game
            whoWinList.map {
                let amount = self.game.result[$0]! + winnerAmount
                if $0 == uid {
                    updateAmount = updateAmount + winnerAmount
                }
                tempGame.result[$0] = amount
            }
            whoLoseList.map {
                let amount = self.game.result[$0]! + loserAmount
                if $0 == uid {
                    updateAmount = updateAmount + loserAmount
                }
                tempGame.result[$0]! = amount
            }
            
            
            let detailCount = self.game.detailCount
            tempGame.detailCount = detailCount + 1
            let year = Int(period.prefix(4))!
            NotificationCenter.default.post(name: .updateUserBalance, object:  (year,updateAmount))
            self.game = tempGame
            self.lastGame = gameDetail
            Utility.hideProgress()
            self.closeFlag.toggle()
        }.catch { (error) in
            Utility.showAlert(message: error.localizedDescription)
        }
    }
       
}
