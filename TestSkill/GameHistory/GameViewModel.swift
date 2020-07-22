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
import FirebaseFirestore


class GameViewModel: ObservableObject {
    
    static let shared = GameViewModel()
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    private var tickets: [AnyCancellable] = []
    var lastDoc : DocumentSnapshot?
    @Published var showGroupDisplay: Bool = false
    @Published var showAddGameDisplay: Bool = false
    @Published var showPercent: Bool = true
    @Published var showingFlownView = false
    @Published var games: [String:[Game]] =  [:]
    @Published var sectionHeader : [String] = []
    @Published var sectionHeaderAmt : [String:Int] = [:]
    @Published var groupUsers: [User] =  []
    @Published var status : pageStatus = .loading
    @Published var group: PlayGroup?{
         didSet{
            print("Setup the group,start fetching game...")
            UserDefaults.standard.save(customObject: group, inKey: UserDefaultsKey.CurrentGroup)
            self.status = .loading
            self.loadGame()
            self.loadUserFromGroup(group:self.group!)
            self.loadPerviousBalance()
         }
     }
    @Published var balanceObject : UpperResultObject = UpperResultObject()
    var noMoreUpdate : Bool = false
    var startAgain : Bool = false
    final var pagingSize : Int = 50
    var lastGameDetail : GameDetail? //for detailView
    var lastBig2GameDetail : Big2GameDetail? //for detailView
    var gameForFlown : Game?
    var actAsUser : User?
    
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
   
        NotificationCenter.default.publisher(for: .loadMoreGame)
            .sink {_ in
                self.loadGame()
           }.store(in: &tickets)
        
        //Pass to the detail view
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
            .map{$0.object as! (Int,Int)}
            .sink { (year,amount) in
                
                var abc = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
                abc.yearBalance[year] =  (abc.yearBalance[year] ?? 0) + amount
                print("add \(amount) to balance result \(abc.yearBalance[year])")
                if year == Utility.getCurrentYear(){
                    self.balanceObject.currentMth += amount
                    self.balanceObject.balance += amount
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
            let uid = Auth.auth().currentUser!.uid
//            print("uid",uid)
            PlayGroup.getByUserId(id: uid).then { (groups) in
                if groups.count == 0 {
                    print("no group was setup up")
                    self.showGroupDisplay = true
                }else{
                    self.group = groups[0]
                }
            }.catch { (error) in
                Utility.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func loadUserFromGroup(group : PlayGroup){
        print("load User Group")
        if let currentGroupUser = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser){
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
    
    
    func loadPerviousBalance(){
        var user = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
        if let actUser = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.ActAsUser){
            user = actUser
        }
        user.getGamesWithin2Year(groupId: group!.id).then { games in
                       
            let previousYear = games.filter{$0.date.prefix(4) == String(Utility.getPerviousYear())}
            let lastYearUpToMth = previousYear.filter{ $0.date.prefix(6) <= Utility.getPYTM()}
            let lastMth = games.filter{ $0.date.prefix(6) == Utility.getLM()}
            var yearBalance = 0
            var mthBalance = 0
            lastYearUpToMth.map{
                yearBalance += $0.result[user.id]!
            }
            lastMth.map{
                mthBalance += $0.result[user.id]!
            }
            
            
            self.balanceObject.lastYTM = yearBalance
            self.balanceObject.lastMth = mthBalance
        }
    }
    
    func loadGame(){
        print("call load Game")
    
        if !noMoreUpdate{

            let actAsUser = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.ActAsUser)
            var uid = actAsUser == nil ? Auth.auth().currentUser!.uid:actAsUser!.id
            
            if startAgain {
                self.games =  [:]
                self.sectionHeader = []
                startAgain.toggle()
            }
            Game.getItemWithGroupId(groupId: self.group!.id ,pagingSize: pagingSize, lastDoc: lastDoc).then { (games,lastDoc)  in
                
                if games.count > 0 {
                    if games.count < self.pagingSize {
                        self.noMoreUpdate = true
                    }
                   var list = self.games.values.flatMap{$0}
                    list += games

                    let currentMthGame = list.filter{$0.date.prefix(6) == Utility.getCM()}
//                    print(Utility.getCM())
//                    print("currentMthBalance ====: \(currentMthGame.count)")
                    var cMB = 0
                    for game in currentMthGame {
                        cMB += game.result[uid] ?? 0
                    }
                    self.balanceObject.currentMth = cMB
//                    print("====: \(self.currentMthBalance)")
                    
                    print("Total Game : \(list.count)")
                    var sorted = list.sorted { $0.date > $1.date }
                    let dictionary = Dictionary(grouping: sorted) { $0.period }
                    DispatchQueue.main.async {
                        self.sectionHeader = dictionary.keys.sorted(by: >)
                        self.sectionHeaderAmt = [:]
                        self.sectionHeader.map { (period)  in
                            let list = dictionary[period]!
                            var amt : Int = 0
                            for item in list {
                                amt = amt + (item.result[uid] ?? 0)
                            }
                            self.sectionHeaderAmt[period] = amt
                        }
                        self.games = dictionary
                        self.lastDoc = lastDoc
                        
//                        for (period ,gameList)  in dictionary {
//                            if period == "202006" {
//                                for abc in gameList {
//                                    print(abc.period)
//                                }
//                            }
//                        }
                        
                    }
                    
                    
                }else{
                    self.noMoreUpdate = true
                    print("Set noMoreUpdate to true2")
                }
            }.catch { (error) in
                print(error.localizedDescription)
                Utility.showAlert(message: error.localizedDescription)
            }.always {
                
                Utility.hideProgress()
            }
        }else{
            noMoreUpdate.toggle()
            lastDoc = nil
            startAgain = true
            Utility.showAlert(message: "no more update , next refresh will refresh from begining ")
        }
            loadGameBalance()
    }

    func updateGame(game:Game){
        print("Trigger the game update \(game.result)")
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
      
    func loadGameBalance(){
        var uid = Auth.auth().currentUser!.uid
        if let actAsUser = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.ActAsUser){
            uid = actAsUser.id
        }
        
        User.getById(id: uid).then{ user in
            print("after get")
            if let user = user {
                self.balanceObject.balance = user.yearBalance[Utility.getCurrentYear()]!
                if let actAsUser = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.ActAsUser){
                    //       uid = actAsUser == nil ? currentUser!.id : actAsUser.id
                }else{
                    UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
                }
            }
        }
    }
    
    func onInitialCheck(){
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor.rgb(red: 225, green: 0, blue: 0)
        self.actAsUser = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.ActAsUser)
        print("actAsUser",actAsUser?.id)
        self.loadUserGroup()
    }
}
