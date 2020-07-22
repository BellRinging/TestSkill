//
//  SearchViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 18/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import FirebaseAuth

class SearchViewModel: ObservableObject {

    @Published var winLoses : [String] = ["Any","Win","Lose"]
    @Published var location : [String] = ["Any","Hei Home","Ricky Home"]
    @Published var periods : [String] = ["Any"]
    @Published var fans : [String] = ["Any"]
    @Published var winType : [String] = ["Any","Self","Other","Special"]
    @Published var selected : Int = 0
    @Published var isOn : Bool = false
    @Published var checkState:Bool = false
    @Published var selectedWinLose:Int = 0
    @Published var selectedPeriodDetailLevel:Int = 0
    @Published var selectedPeriodGameLevel:Int = 0
    @Published var selectedFanDetailLevel:Int = 0
    @Published var selectedLocation:Int = 0
    @Published var selectedWinType:Int = 0
    
    
    @Published var amount:String = "0"
    @Published var radioSelection:String = "Game Detail"
    @Published var radioWinLoses:String = "Any"
    @Published var playersDetailLevel : [User] = []
    @Published var playersGameLevel : [User] = []
    @Published var playersExclude : [User] = []
    @Published var showSelectPlayerDetailLevel : Bool = false
    @Published var showSelectPlayerGameLevel : Bool = false
    @Published var showSearchGame : Bool = false
    @Published var showSelectGame : Bool = false
    @Published var showSearchGameDetail : Bool = false
    @Published var showExcludePlayer : Bool = false
    
    
    @Published var selectedGame : Game?
    var games : [Game] = []
    var gameDetails : [GameDetail] = []
    var refUser : User?
      
    let periodFormater : DateFormatter = {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyyMM"
        return dateFormatterPrint
    }()
    
    func initPeriod(){
        var dateComponent = DateComponents()
        let currDate = Date()
        var result : [String] = ["Any"]
        for index in 0...23 {
            dateComponent.month = index * -1
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currDate) as! Date
            result.append(periodFormater.string(from: futureDate))
        }
        self.periods = result
    }
    
    func initFan(){
        let group = UserDefaults.standard.retrieve(object: PlayGroup.self, fromKey: UserDefaultsKey.CurrentGroup)
        var result : [String] = ["Any"]
        if let group = group {
            for index in group.startFan...group.endFan {
                result.append("\(index)")
            }
        }
        self.fans = result
    }
    
    init() {
        
    }
    
    func search(){
         let uid = Auth.auth().currentUser!.uid
        print("user:\(uid)")
        if self.radioSelection == "Game" {
            Game.search(
                                  userId: uid,
                                  period: periods[selectedPeriodGameLevel],
                                  win: radioWinLoses,
                                  amount: Int(amount) ?? 0,
                                  players: playersGameLevel,
                                  playerExclude: playersExclude,
                                  location: location[selectedLocation]
                              ).then { (games) in
                                  print(games.count)
                                self.games = games
                                self.showSearchGame = true
                                
                              }
        }else {
            self.refUser = playersDetailLevel.count == 0 ? nil:playersDetailLevel[0]
            GameDetail.search(fan: fans[selectedFanDetailLevel] ,
                              period: periods[selectedPeriodDetailLevel],
                              win: winLoses[selectedWinLose],
                              winType: winType[selectedWinType],
                              game: selectedGame,
                              player: self.refUser)
                .then { (gameDetails) in
                    self.gameDetails = gameDetails
                    print("show detail \(gameDetails.count)" )
                    self.showSearchGameDetail = true
            }.catch { (err) in
                print(err.localizedDescription)
            }
        }
    }
    
}
