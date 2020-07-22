//
//  ChatDetailViewModel.swift
//  QBChat-MVVM
//
//  Created by Paul Kraft on 30.10.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import Promises


class SearchGameDetailViewModel: ObservableObject {
    
    @Published var displayResult: [String:[GameDetail]] = [:]
    var gameDetails: [GameDetail]
    @Published var sectionHeader: [String] = []
    @Published var sectionHeaderAmt : [String:Int] = [:]
    @Published var sectionHeaderString : [String:String] = [:]
    @Binding var closeFlag : Bool
    var refUser : User?
    var groupUser : [User]
        
    
    init(closeFlag : Binding<Bool>,gameDetails :[GameDetail],refUser : User?) {
        self._closeFlag = closeFlag
        self.gameDetails = gameDetails
        self.groupUser = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser)!
        self.refUser = refUser
        let gameList = Array(Set(gameDetails.map{$0.gameId}))
        var promiseList : [Promise<Game>] = []
        gameList.map {
            promiseList.append(Game.getItemById(gameId: $0))
        }
        Promises.all(promiseList).then{ games in
            games.map{
                self.sectionHeaderString[$0.id] = "\($0.date) \($0.location)"
            }
            self.covertDisplay()
        }.catch{ err in
            Utility.showAlert(message: "error")
        }
    }
    
    func covertDisplay(){
        
        let list = gameDetails
        var sorted = list.sorted { $0.createDateTime < $1.createDateTime }
        let dictionary = Dictionary(grouping: sorted) { $0.gameId}
        self.sectionHeader = dictionary.keys.sorted(by: >)
//        self.sectionHeaderAmt = [:]
//        self.sectionHeader.map { (gameId)  in
//            let list = dictionary[gameId]!
//            var amt : Int = 0
//            if refUser != nil{
//                for item in list {
//                    amt = amt +
//                }
//            }
//            self.sectionHeaderAmt[gameId] = amt
//        }
        self.displayResult = dictionary
    }
    
}



