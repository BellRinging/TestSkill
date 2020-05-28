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
     @Published var showingFlownView = false
//    @Published var showAddFriend: Bool = false
    @Published var games: [String:[Game]] =  [:]
    @Published var sectionHeader : [String] = []
    @Published var sectionHeaderAmt : [String:Int] = [:]
    @Published var groupUsers: [User] =  []
    @Published var currentUser: User?
    @Published var status : pageStatus = .loading
    @Published var mthCredit : Int = 0
    @Published var mthDebit: Int = 0
    @Published var group: PlayGroup?{
         didSet{
            print("Setup the group,start fetching game...")
            UserDefaults.standard.save(customObject: group, inKey: UserDefaultsKey.CurrentGroup)
            self.status = .loading
            self.loadGameFromGroup(group:self.group!)
            self.loadUserFromGroup(group:self.group!)
         }
     }
    var noMoreUpdate : Bool = false
    var startAgain : Bool = false
    final var pagingSize : Int = 50
    var lastGameDetail : GameDetail? //for detailView
    var lastBig2GameDetail : Big2GameDetail? //for detailView
    var gameForFlown : Game?
    
    init() {
        print("GameView Model init")
        addObservor()
    }
    
    func addObservor(){
        
        //For update game when add a detail
        NotificationCenter.default.publisher(for: .updateGame)
            .map{$0.object as! Game}
            .sink { [unowned self] (game) in
                    self.updateGame(game: game)
        }.store(in: &tickets)
        
        NotificationCenter.default.publisher(for: .updateLastGameRecord)
            .map{$0.object as! GameDetail?}
            .sink { [unowned self] (gameDetail) in
                    self.lastGameDetail = gameDetail
        }.store(in: &tickets)
        
        NotificationCenter.default.publisher(for: .updateLastBig2GameRecord)
            .map{$0.object as! Big2GameDetail?}
            .sink { [unowned self] (big2GameDetail) in
                    self.lastBig2GameDetail = big2GameDetail
        }.store(in: &tickets)
        
        NotificationCenter.default.publisher(for: .deleteGame)
              .map{$0.object as! Game?}
              .sink { [unowned self] (game) in
                print("delete game")
                let period = game!.period
                let index = self.games[period]!.firstIndex { $0.id == game!.id}!
                self.deleteGame(section: period, index: index)
          }.store(in: &tickets)
        
        NotificationCenter.default.publisher(for: .flownGame)
              .map{$0.object as! Game?}
              .sink { [unowned self] (game) in
                self.gameForFlown = game
                if game!.flown == 1 {
                    Utility.showAlert(message: "Game already Flown")
                    return
                }
                withAnimation {
                    self.showingFlownView = true
                }
          }.store(in: &tickets)
        
        NotificationCenter.default.publisher(for: .updateUserBalance)
                .map{$0.object as! Int}
                .sink { (amount) in
                    
                    var abc = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
                    abc.balance =  abc.balance + amount
                    print("add \(amount) to balance result \(abc.balance)")
                    DispatchQueue.main.async {
                        self.currentUser = abc
                    }
                    UserDefaults.standard.save(customObject: abc, inKey: UserDefaultsKey.CurrentUser)
            }.store(in: &tickets)
    }
    
    func loadUserGroup(){
        let group = UserDefaults.standard.retrieve(object: PlayGroup.self, fromKey: UserDefaultsKey.CurrentGroup)
        if let group = group {
            print("group from userdefault")
            self.group = group
        }else{
            print("no group")
            guard let uid = Auth.auth().currentUser?.uid else {
                print("Error , if login , it should not be no group")
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LoginFlag)
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
                Utility.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func loadUserFromGroup(group : PlayGroup){
        print("load User Group")
        if let currentGroupUser = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser){
//            print("init \(currentGroupUser.count) users from userDefault")
//            print(currentGroupUser.map{$0.id})
            self.groupUsers = currentGroupUser
            self.status = .completed
        }else{
            background.async {
                var promiseList : [Promise<User?>] = []
                group.players.map{
                    promiseList.append(User.getById(id: $0))
                }
                Promises.all(promiseList).then{ users in
                    var result : [User] = []
                    for user in users {
                        if user != nil {
                            result.append(user!)
                        }
                    }
                    DispatchQueue.main.async {
                        self.groupUsers = result
                        UserDefaults.standard.save(customObject: self.groupUsers, inKey: UserDefaultsKey.CurrentGroupUser)
                        print("Store \(self.groupUsers.count) users from Group \(group.groupName) into UserDefault")
                        self.status = .completed
                    }
                }
            }
        }
    }
    
    
    func loadMoreGame(){
//        print("call load Game")
        loadGameBalance()
        if !noMoreUpdate{
            let uid = Auth.auth().currentUser!.uid
            if startAgain {
                self.games =  [:]
                self.sectionHeader = []
                startAgain.toggle()
            }
            Game.getItemWithUserId(userId: uid, groupId: self.group!.id ,pagingSize: pagingSize, lastDoc: lastDoc).then { (games,lastDoc)  in
                
                if games.count > 0 {
                    if games.count <= self.pagingSize {
                        self.noMoreUpdate = true
                    }
                   var list = self.games.values.flatMap{$0}
                    list += games
                    var sorted = list.sorted { $0.date > $1.date }
                    let dictionary = Dictionary(grouping: sorted) { $0.period }
                    DispatchQueue.main.async {
                        print("Set the games")
                        self.sectionHeader = dictionary.keys.sorted(by: >)
                        self.sectionHeaderAmt = [:]
                        self.sectionHeader.map { (period)  in
                            let list = dictionary[period]!
                            var amt : Int = 0
                            for item in list {
                                amt = amt + item.result[uid]!
                            }
                            self.sectionHeaderAmt[period] = amt
                        }
                        self.games = dictionary
                        self.lastDoc = lastDoc
                    }
                }else{
                    self.noMoreUpdate = true
                }

            }.catch { (error) in
                print(error.localizedDescription)
                Utility.showAlert(message: error.localizedDescription)
            }
        }else{
            noMoreUpdate.toggle()
            lastDoc = nil
            startAgain = true
            Utility.showAlert(message: "no more update , next refresh will refresh from begining ")
        }
    }
    
    func loadGameFromGroup(group : PlayGroup){
        print("call load Game")
        if let uid = Auth.auth().currentUser?.uid {
            Game.getItemWithUserId(userId: uid,groupId: group.id, pagingSize: pagingSize).then { (games,lastDoc)  in
                var sorted = games.sorted { $0.date > $1.date }
                if games.count < self.pagingSize {
                    self.noMoreUpdate = true
                }
//                print(self.noMoreUpdate)
                let dictionary = Dictionary(grouping: sorted) { $0.period }

                
                DispatchQueue.main.async {
                    self.sectionHeader = dictionary.keys.sorted(by: >)
                    self.sectionHeader.map { (period)  in
                        let list = dictionary[period]!
                        var amt : Int = 0
                        for item in list {
                            amt = amt + item.result[uid]!
                        }
                        self.sectionHeaderAmt[period] = amt
                    }
//                    print(self.sectionHeader)
                    self.games = dictionary
                    self.lastDoc = lastDoc
                }
            }.catch { (error) in
                print(error.localizedDescription)
                Utility.showAlert(message: error.localizedDescription)
            }
        }
        
    }
    

    func updateGame(game:Game){
        print("Trigger the game update \(game.result)")
//        print(game)
        let period = game.period
        var gameArray : [Game] = []
        if let gamesList = self.games[period]  {
            gameArray = gamesList
            let index = gamesList.firstIndex { $0.id == game.id}
            if let index = index {
                print("update the result game")
                for i in 0..<gameArray.count{
                    if gameArray[i].id == game.id{
                        DispatchQueue.main.async {
                            self.games[period]![i] = game
                        }
                    }
                }
            }else{
                print("Add New game")
                self.games[period]?.insert(game, at: 0)
            }
        }else{
            print("Add New game")
            self.sectionHeader.append(period)
            let uid = Auth.auth().currentUser!.uid
            self.sectionHeaderAmt[period] = game.result[uid]!
            self.sectionHeader.sort {$0 > $1}
            self.games[period] = [game]
        }
        Utility.hideProgress()
    }
    
    func deleteGame(section : String , index : Int){
        print("\(section) index \(index)" )
        withAnimation{
            let game = self.games[section]![index]
            if game.flown == 1 {
                Utility.showAlert(message: "Game is already frown")
                return
            }
            let gameId = game.id
            GameDetail.getAllItemById(gameId: gameId).then { gameDetail in
                print("gameDetail \(gameDetail.count)")
                if (gameDetail.count > 1){
                    Utility.showAlert(message: "Cant delete if game has already started")
                }else{
                    game.delete()
                    DispatchQueue.main.async {
                        if self.games[section]!.count >  1 {
                            self.games[section]!.remove(at: index)
                        }else{
                            let temp = self.sectionHeader.firstIndex(of: section)
                            self.sectionHeader.remove(at: temp!)
                            self.games.removeValue(forKey: section)
                        }
                    }
                        
                }
            }
        }
    }
    
    func updateUserBalance(){
        
    }
      
    func loadGameBalance(){
        let uid = Auth.auth().currentUser!.uid
        User.getById(id: uid).then{ user in
            DispatchQueue.main.async {
                self.currentUser = user
                UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
            }
        }.catch { (error) in
            Utility.showAlert(message: error.localizedDescription)
        }
    }
    
    func onInitialCheck(){
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor.rgb(red: 225, green: 0, blue: 0)
//        print(UIApplication.shared.statusBarUIView)
        self.loadUserGroup()
    }
}
