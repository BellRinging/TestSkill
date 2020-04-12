//
//  FlownGameViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import SwiftUI


class UpdateBalanceViewModel : ObservableObject {

    @Binding var closeFlag : Bool
    @Published var player : User
    @Published var player1OAmt : String = ""
    @Published var player1Amt : String = ""
    @Published var showAlert : Bool = false
    
    init(closeFlag : Binding<Bool>){
        self._closeFlag = closeFlag
        self.player = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
        self.player1OAmt = "\(player.balance ?? 0)"
        self.player1Amt = "\(player.balance ?? 0)"
    }
    
    
    func confirm(){
      
        if player1Amt == "" {
            Utility.showAlert(message: "Amt not in right format")
            return
        }
        player.updateBalance(value: Int(player1Amt)! ,absoluteValue: true)
        player.balance = Int(player1Amt)!
        UserDefaults.standard.save(customObject: player, inKey: UserDefaultsKey.CurrentUser)
        closeFlag.toggle()
        
    }
}
