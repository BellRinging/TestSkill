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
    var game : Game
    var hasLoser : Bool = false
    var group : PlayGroup?
    var specialItemAmt : Int = 50
    
    
    init(closeFlag : Binding<Bool>,game : Game){
        self._closeFlag = closeFlag
        self.game = game
        print("init Special")
        if let userInGroup = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser){
            for playerId in game.playersId {
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
        for i in 0...2 {
            if (self.playersOffset[i] >= lose1xPosition ){
                self.playersAmt[i] = playersOffset[i] == lose1xPosition ? specialItemAmt : specialItemAmt*2
                totalAmount = totalAmount + self.playersAmt[i]
            }
        }
        //loser amount
        for i in 0...2 {
            if (self.playersOffset[i] < lose1xPosition ){
                self.playersAmt[i] =  totalAmount * -1
                break
            }
        }
    }
    
    

    func markSpecial(){
        
        if (!hasLoser){
            Utility.showAlert(message: "Not valid setting")
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
        
    
        for i in 0...2 {
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
            
            for i in 0...2 {
                let amount = self.game.result[self.players[i].id]! + winnerAmount
                if self.players[i].id == uid {
                    updateAmount = updateAmount + winnerAmount
                }
                self.game.result[self.players[i].id]! = amount
            }
          
            let detailCount = self.game.detailCount
            self.game.detailCount = detailCount + 1
            NotificationCenter.default.post(name: .updateUserBalance, object:  updateAmount)
            NotificationCenter.default.post(name: .updateLastGameRecord, object:  gameDetail)
            NotificationCenter.default.post(name: .updateGame, object:  self.game)
            self.closeFlag.toggle()
        }.catch { (error) in
            Utility.showAlert(message: error.localizedDescription)
        }
    }
       
}
