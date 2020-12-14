//
//  ResultViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 8/6/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine
import SwiftUI



class ResultViewModel: ObservableObject {
    
    @Published var result : [resultObj] = []
    @Published var periods : [String] = []
    @Published var selectedPeriod : String = "" {
        didSet{
            self.background.async {
                self.convert(users:self.groupUser)
            }
        }
    }
    @Published var showSelect : Bool = false
    @Binding var closeFlag : Bool
    var groupUser : [User]
    
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    
    init(closeFlag : Binding<Bool> ){
        self._closeFlag = closeFlag
        self.groupUser = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser)!
   
        
     
    }
    
    func convert(users : [User]){
        print(selectedPeriod)
        result = []
        let group = UserDefaults.standard.retrieve(object: PlayGroup.self, fromKey: UserDefaultsKey.CurrentGroup)!
        for user in users {
            User.getGamesWithin2Year(groupId: group.id,uid: user.id).then { games in
                
                let sorted = games.sorted{$0.date > $1.date}
//                print("sorted",sorted.count)
                let ytd = sorted.filter{$0.date.prefix(6) <= self.selectedPeriod}
//                print("ytd",ytd.count)
                var last6GameResult : [String] = []
                let filtered = ytd.prefix(6)
                for game in filtered{
                    last6GameResult.append(game.result[user.id]! > 0 ? "W":"L")
                }
                let thisYear = ytd.filter{$0.date.prefix(4) == self.selectedPeriod.prefix(4)}
                let numOfGame = thisYear.count
                var winCount = 0
                var yearBalance = 0
                thisYear.map{
                    if $0.result[user.id]! > 0 {
                        winCount += 1
                    }
                    yearBalance += $0.result[user.id]!
                }
                let percent = numOfGame == 0 ? "N/A":"\(Int(Float(winCount)/Float(numOfGame) * 100))%"
                DispatchQueue.main.async {
                    self.result.append(resultObj(id: UUID().uuidString , user: user, last6GameResult: last6GameResult, numberOfGame: numOfGame, yearBalance: yearBalance, winCount: winCount, winPercent: percent))
                    self.result = self.result.sorted{$0.yearBalance > $1.yearBalance}
                }
            }
        }
    }
    
}

struct resultObj : Identifiable , Hashable{
    var id : String
    var user : User
    var last6GameResult : [String]
    var numberOfGame : Int
    var yearBalance : Int
    var winCount : Int
    var winPercent : String
}
    
