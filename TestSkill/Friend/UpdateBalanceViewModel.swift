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
    @Published var years : [Int] = []
    var amtForDisplay : [String] = []
    @Published var amtForEdit : [String] = []
    @Published var showAlert : Bool = false
    
    init(closeFlag : Binding<Bool>){
        self._closeFlag = closeFlag
        self.player = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
        print("Current : \(player.userName)")
        let yearBalance = player.yearBalance
        for year in yearBalance.keys{
            years.append(year)
            let amount = player.yearBalance[year] ?? 0
            amtForDisplay.append("\(amount)")
            amtForEdit.append("\(amount)")
        }
       
    }
    
    
    func confirm(){
        for amt in amtForEdit {
            if amt == "" {
                Utility.showAlert(message: "Amt not in right format")
                return
            }
        }
        
        for i in 0...self.years.count - 1{
            let year = years[i]
            let amt = Int(amtForEdit[i])!
            player.updateBalance(value: amt,year: year ,absoluteValue: true)
            player.yearBalance[year] = amt
            UserDefaults.standard.save(customObject: player, inKey: UserDefaultsKey.CurrentUser)
        }
        


        closeFlag.toggle()
        
    }
}
