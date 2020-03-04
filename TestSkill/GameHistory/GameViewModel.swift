//
//  ChatDetailViewModel.swift
//  QBChat-MVVM
//
//  Created by Paul Kraft on 30.10.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth
import Promises
import SwiftEntryKit
import SwiftUI
import Firebase


class GameViewModel: ObservableObject {
    
    static let shared = GameViewModel()

    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    private var tickets: [AnyCancellable] = []
    var lastDoc : DocumentSnapshot?
    @Published var showGroupDisplay: Bool = false
    @Published var showAddGameDisplay: Bool = false
    @Published var games: [String:[Game]] =  [:]
    @Published var sectionHeader : [String] = []
    @Published var groupUsers: [User] =  []
    @Published var status : pageStatus = .loading
    @Published var group: PlayGroup?{
         didSet{
            print("did Set the group")
             self.loadGameFromGroup(group:self.group!)
             self.loadUserFromGroup(group:self.group!)
         }
     }
    
    init() {
        addObservor()
    }
    
    func addObservor(){
        NotificationCenter.default.publisher(for: .dismissAddGameView)
            .sink { [unowned self] (_) in
            self.showAddGameDisplay = false
        }.store(in: &tickets)
        
        NotificationCenter.default.publisher(for: .updateGame)
            .map{$0.object as! String}
            .sink { [unowned self] (gameId) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.updateGame(gameId: gameId)
                }
        }.store(in: &tickets)
    }
    
    func loadUserGroup(){
        let group = UserDefaults.standard.retrieve(object: PlayGroup.self, fromKey: UserDefaultsKey.CurrentGroup)
        if let group = group {
            self.group = group
        }else{
            guard let uid = Auth.auth().currentUser?.uid else {
                print("Error , if login , it should not be no group")
                return
            }
            PlayGroup.getByUserId(id: uid).then { (groups) in
                if groups.count == 0 {
                    print("no group was setup up")
                    self.showGroupDisplay = true
                }else{
                    self.group = groups[0]
                    UserDefaults.standard.save(customObject: self.group, inKey: UserDefaultsKey.CurrentGroup)
                }
            }.catch { (error) in
                Utility.showError(message: error.localizedDescription)
            }
        }
    }
    
    func loadUserFromGroup(group : PlayGroup){
//        Utility.showProgress()
        background.async {
            for user in group.players {
                let user = try? await(User.getById(id: user))
//                print("get User \(user)")
                if user != nil {
                    self.groupUsers.append(user!)
                }
            }
            DispatchQueue.main.async {
                print("Set the Users")
                self.status = .completed
            }
        }
    }
    
    func loadGameFromGroup(group : PlayGroup){
        let uid = Auth.auth().currentUser!.uid
        Game.getItemWithUserId(userId: uid).then { (games,lastDoc)  in
            var sorted = games.sorted { $0.date > $1.date }
            let dictionary = Dictionary(grouping: sorted) { $0.period }
            DispatchQueue.main.async {
                print("Set the games")
                self.sectionHeader = dictionary.keys.sorted(by: >)
                self.games = dictionary
                self.lastDoc = lastDoc
            }
        }.catch { (error) in
            Utility.showError(message: error.localizedDescription)
        }
    }
    
    func updateGame(gameId:String){
        print("Trigger the game update ")
        Game.getItemById(gameId: gameId).then { (game)in
            let period = game.period
//            print("Result \(game.result)")
//            print("period \(period)")
//            print("Game \(self.games[period]?.count)")
            let gameArray = self.games[period]!
            for i in 0..<gameArray.count{
                if gameArray[i].id == game.id{
                    self.games[period]![i] = game
                }
            }
        }
    }
}
