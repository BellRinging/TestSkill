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
    @Published var showingFlownView = false
    @Published var games: GameList = GameList(list: [])
    var isLoading : Bool = false
    
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
    final var pagingSize : Int = 50
    var gameForFlown : Game?
    var actAsUser : User?
    
    init() {
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
        
        
        NotificationCenter.default.publisher(for: .deleteGame)
            .map{$0.object as! Game}
            .sink { [unowned self] (game) in
//                let period = game!.period
//                let index = self.games[period]!.firstIndex { $0.id == game!.id}!
                self.deleteGame(game: game)
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
            PlayGroup.getByUserId(id: uid).then { (groups) in
                if groups.count == 0 {
                    print("no group was setup up")
                    self.status = .error
                }else{
                    self.group = groups[0]
                }
            }.catch { (error) in
                Utility.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func loadUserFromGroup(group : PlayGroup){
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
                    let result = users.compactMap{$0}
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
        let uid = Utility.getUserId()
        User.getGamesWithin2Year(groupId: group!.id ,uid: uid).then { games in
            let previousYear = games.filter{$0.date.prefix(4) == String(Utility.getPerviousYear())}
            let lastYearUpToMth = previousYear.filter{ $0.date.prefix(6) <= Utility.getPYTM()}
            let lastMth = games.filter{ $0.date.prefix(6) == Utility.getLM()}
            var yearBalance = 0
            var mthBalance = 0
            lastYearUpToMth.map{
                yearBalance += $0.result[uid]!
            }
            lastMth.map{
                mthBalance += $0.result[uid]!
            }
            
            
            self.balanceObject.lastYTM = yearBalance
            self.balanceObject.lastMth = mthBalance
        }
    }
    
    func calculateCurrentMonth(_ list:[Game],_ uid: String){
        let currentMthGame = list.filter{$0.date.prefix(6) == Utility.getCM()}
        var cMB = 0
        for game in currentMthGame {
            cMB += game.result[uid] ?? 0
        }
        self.balanceObject.currentMth = cMB
    }
    
    func loadGame(){
        if !self.games.noMoreGame{
            
            if self.isLoading {
                return
            }
            self.isLoading = true
            if self.games.startAgain {
                self.games = GameList(list: [])
                self.games.startAgain.toggle()
            }
            let uid = Utility.getUserId()
            Game.getItemWithGroupId(groupId: self.group!.id ,pagingSize: pagingSize, lastDoc: lastDoc).then { (gameList,lastDoc)  in
                
                if gameList.count > 0 {
                    if gameList.count < self.pagingSize {
                        self.games.noMoreGame = true
                    }
                    var list = self.games.list.count == 0 ? [] : self.games.list.flatMap{$0.games}
                    list += gameList
                    print("Total Game : \(list.count)")
                    self.calculateCurrentMonth(list,uid)
                    let sorted = list.sorted { $0.date > $1.date }
                    let dictionary = Dictionary(grouping: sorted) { $0.period }
                    var result : [GamePassingObject] = []
                    let sectionHeader = dictionary.keys.sorted(by: >)
                    for period in sectionHeader{
                        let list = dictionary[period]!
                        let amt : Int = list.reduce(0) { oldValue, item in
                            oldValue + (item.result[uid] ?? 0)
                        }
                        let gameObj = GamePassingObject(id: period, games: list, periodAmt: amt)
                        result.append(gameObj)
                    }
                    self.games = GameList(list: result)
                    self.lastDoc = lastDoc
                    self.loadGameBalance()
                }else{
                    self.games.noMoreGame = true
                }
            }.catch { (error) in
                Utility.showAlert(message: error.localizedDescription)
            }.always {
                self.isLoading = false
                Utility.hideProgress()
            }
        }else{
            self.games.noMoreGame.toggle()
            lastDoc = nil
            self.games.startAgain = true
            Utility.showAlert(message: "no more update , next refresh will refresh from begining ")
        }
       
    }

    func updateGame(game:Game){
        print("Trigger the game update \(game.result)")
        self.games.updateGame(game: game)
        Utility.hideProgress()
    }
    
    func deleteGame(game : Game){
        withAnimation{
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
                    self.games.deleteGame(game: game)
                }
            }
        }
    }
    
    
    func deleteGame(period : String , index : Int){
        let index1 = self.games.list.firstIndex{$0.id == period}!
        self.deleteGame(game: self.games.list[index1].games[index])
    }
      
    func loadGameBalance(){
        let uid = Utility.getUserId()
        User.getById(id: uid).then{ user in
            if let user = user {
                self.balanceObject.balance = user.yearBalance[Utility.getCurrentYear()]!
                if UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.ActAsUser) == nil {
                    UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
                }
            }
        }
    }
    
    func onInitialCheck(){
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor.rgb(red: 225, green: 0, blue: 0)
        self.actAsUser = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.ActAsUser)
        self.loadUserGroup()
    }
}

