//
//  ChatDetailViewModel.swift
//  QBChat-MVVM
//
//  Created by Paul Kraft on 30.10.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine
import SwiftUI



class AddPlayGroupViewModel: ObservableObject {
    
    @Binding var closeFlag : Bool
    @Binding var editGroup : PlayGroup?
    var userA : Int = 0
    var userB : Int = 0 
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    
    @Published var fan : [String] = Array<String>(repeating: "", count: 11)
    @Published var fanSelf : [String] = Array<String>(repeating: "", count: 11)
    @Published var startFan = 3
    @Published var endFan = 10
    @Published var showPlayerSelection = false
    @Published var groupName = ""
    @Published var players : [User]
    @Published var playerSelected = ""
    
    init(closeFlag : Binding<Bool> , editGroup : Binding<PlayGroup?> ){
        self._closeFlag = closeFlag
        self._editGroup = editGroup
        players = []
        if let group = editGroup.wrappedValue{
            loadPlayerByArray(array: group.players)
            loadRule(group: group)
            self.groupName = group.groupName
            self.startFan = group.startFan
            self.endFan = group.endFan
        }else{
            loadPlayer()
        }
    }

    func addFriend(){
        //        guard let userA = userA , let userB = userB else {return}
        print("Add Friend")
        //        let playerA = players.filter(<#T##isIncluded: (User) throws -> Bool##(User) throws -> Bool#>)
        players[userA].updateFriend(userId: players[userB].id)
        players[userA].friends.append(players[userB].id)
        players[userB].updateFriend(userId: players[userA].id)
        players[userB].friends.append(players[userA].id)
        Utility.showAlert(message: "They are friend now")
    }
    
    
    func addGroup(){
        if !checking() { return }
        Utility.showProgress()
        var playGroup = PlayGroup()
        if let isEdit = editGroup {
            //Edit
            playGroup = isEdit
        }else{
            //NewAdd
            playGroup.id =  UUID().uuidString
        }
        playGroup.groupName = self.groupName
        playGroup.players = players.map{$0.id}
        playGroup.playersName = players.map{$0.userName ?? ""}
        playGroup.rule = toRule()
        playGroup.ruleSelf = toRuleSelf()
        playGroup.startFan = self.startFan
        playGroup.endFan = self.endFan
        playGroup.save().then { (group) in
            if let _ = self.editGroup {
                self.editGroup = group
                //just update the selected group only cant update groups object
                NotificationCenter.default.post(name: .addPlayGroup, object: group)
            }else{
                print("Post add")
                NotificationCenter.default.post(name: .addPlayGroup, object: group)
            }
            self.closeFlag.toggle()
        }.catch { (err) in
            Utility.showAlert(message: err.localizedDescription)
        }.always {
            Utility.hideProgress()
        }
    }
    
    
    func toRule() -> Dictionary<Int, Int>{
        var rule : [Int:Int] = [:]
        for i in startFan...endFan {
            rule[i] = Int(fan[i]) ?? 0
        }
        return rule
    }
    
    func toRuleSelf() -> Dictionary<Int, Int>{
        var ruleSelf : [Int:Int] = [:]
        for i in startFan...endFan {
            ruleSelf[i] = Int(fanSelf[i]) ?? 0
        }
        return ruleSelf
    }
    
    func loadRule(group : PlayGroup){
        let start = group.startFan
        let end = group.endFan
        let rule = group.rule
        let ruleSelf = group.ruleSelf
        for i in start...end {
            self.fan[i] = "\(rule[i]!)" 
            self.fanSelf[i] = "\(ruleSelf[i]!)"
        }
    }

    
    func loadPlayerByArray(array : [String]){
        
        guard let userA = Auth.auth().currentUser else {return }
        self.background.sync {
            self.players = []
            for key in array {
                User.getById(id: key).then {[unowned self] (user) in
                    guard let user = user else {return}
                    if (!self.players.contains(user)){
                        self.players.append(user)
                    }
                }.catch{ err in
                    Utility.showAlert(message: err.localizedDescription)
                }
            }
        }
    }
    
    func loadPlayer(){
        guard let userA = Auth.auth().currentUser else {return }
        self.background.sync {
            User.getById(id: userA.uid).then { [unowned self] (user) in
                guard let user = user else  {return}
                if (!(self.players.contains(user))){
                    DispatchQueue.main.async {
                        self.players.append(user)
                    }
                }
            }.catch{ err in
                Utility.showAlert(message: err.localizedDescription)
            }
        }
    }
    

        func checking() -> Bool {
            for i in startFan...endFan {
                let fan = Int(self.fan[i]) ?? 0
                let fanSelf = Int(self.fanSelf[i]) ?? 0
                
                if fan == 0  || fanSelf == 0 {
                    Utility.showAlert(message: "\(i) fan not yet denfined")
                    return false
                }
            }
            if self.groupName == "" {
                 Utility.showAlert(message: "Group Name is not yet denfined")
                return false
            }
            let count = players.count
            for index in 0...(count - 1){
                for index2 in 0...(count - 1){
                    let id2 = players[index2].id
                    if !players[index].friends.contains(id2) && index != index2{
                        self.userA = index
                        self.userB = index2
                        Utility.showAlert(message: "\(players[index].userName) and \(players[index2].userName) are not a fds yet, add them as fds?",callBack:addFriend)
                        return false
                    }
                }
            }
     
            return true
        }


}
