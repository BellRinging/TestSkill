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




class AddPlayGroupViewModel: ObservableObject {

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
    
    weak var parent : DisplayPlayGroupViewModel?{
        didSet{
                print("didset")
            guard let group = parent?.selectedGroup else {return}
            startFan = group.startFan
            endFan = group.endFan
            groupName = group.groupName
            loadPlayerByDictory(dict:group.players)
            loadRule(group:group)
        }
    }
    
    @Published var playerSelected = ""
    
    init(){
        players = []
        loadPlayer()
    }


    
    func addGroup(){
        if !checking() { return }
        Utility.showProgress()
        var playGroup = PlayGroup()
        if let parent = self.parent {
            //Edit
            playGroup = parent.selectedGroup!
        }else{
            //NewAdd
            playGroup.id = parent == nil ? UUID().uuidString : parent!.selectedGroup!.id
        }
        playGroup.groupName = self.groupName
        playGroup.players = toPlayerByDictory(players: self.players)
        playGroup.rule = toRule()
        playGroup.startFan = self.startFan
        playGroup.endFan = self.endFan
        self.background.async {
            playGroup.save().then { (group) in
                print("Success")
                self.parent?.showAddingGroup.toggle()
                self.parent?.loadGroup()
                self.parent?.selectedGroup = group
            }.catch { (err) in
                Utility.showError(message: err.localizedDescription)
            }.always {
                Utility.hideProgress()
            }
        }
        
    }
    
    
    func toRule() -> Dictionary<Int, Int>{
        var rule : [Int:Int] = [:]
        for i in startFan...endFan {
            rule[i] = Int(fan[i]) ?? 0
            rule[i*10] = Int(fanSelf[i]) ?? 0
        }
        return rule
    }
    
    func loadRule(group : PlayGroup){
        let start = group.startFan
        let end = group.endFan
        let rule = group.rule
        for i in start...end {
            self.fan[i] = "\(rule[i]!)" 
            self.fanSelf[i] = "\(rule[i*10]!)"
        }
    }
    
    func toPlayerByDictory(players : [User]) -> Dictionary<String, String>{
        let key = players.map{$0.id}
        print(key)
        let value = players.map{$0.userName!}
        print(value)
        return Dictionary(uniqueKeysWithValues: zip(key,value))
    }
    
    func loadPlayerByDictory(dict : Dictionary<String,String>){
        
        self.background.sync {
            self.players = []
            for (key,_) in dict {
                print("\(key)" )
                User.getById(id: key).then { (user) in
                    guard let user = user else {return}
                    if (!self.players.contains(user)){
                        self.players.append(user)
                    }
                }.catch{ err in
                    Utility.showError(message: err.localizedDescription)
                }
            }
        }
    }
    
    func loadPlayer(){
        guard let userA = Auth.auth().currentUser else {return }
        self.background.sync {
            User.getById(id: userA.uid).then { (user) in
                guard let user = user else {return}
                if (!self.players.contains(user)){
                    self.players.append(user)
                }
            }.catch{ err in
                Utility.showError(message: err.localizedDescription)
            }
        }
    }
    

        func checking() -> Bool {
            for i in startFan...endFan {
                let fan = Int(self.fan[i]) ?? 0
                let fanSelf = Int(self.fanSelf[i]) ?? 0
                
                if fan == 0  || fanSelf == 0 {
                    Utility.showError(message: "\(i) fan not yet denfined")
                    return false
                }
            }
     
            return true
        }


}
