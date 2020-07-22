
import Foundation
import SwiftUI
import Combine


class GameViewListAreaViewModel: ObservableObject {

    
    var groupUsers : [User]
    var sectionHeader : [String]
    var sectionHeaderAmt : [String:Int]
    var games : [String:[Game]]
    var status : pageStatus
    var callback : (String,Int) -> ()
    var selectedPeriod : String = ""
    var selectedIndex : Int = 0
    var lastGameDetail : GameDetail?
    var lastBig2GameDetail : Big2GameDetail?
    var gameForFlown : Game?
    @Published var showingDeleteAlert = false
    @Published var showingFlowView = false
    @Published var isShowing = false
    @Published var isLoading = false
    var noMoreGame = false
    
    
    init(
         sectionHeader: [String],
         sectionHeaderAmt: [String:Int],
         games:[String:[Game]],
         status: pageStatus,
         lastGameDetail:GameDetail?,
          noMoreGame:Bool,
         callback : @escaping (String,Int) -> () ){
        self.groupUsers = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser)!
        self.sectionHeader = sectionHeader
        self.sectionHeaderAmt = sectionHeaderAmt
        self.games = games
        self.status = status
        self.lastGameDetail = lastGameDetail
        self.noMoreGame = noMoreGame
        self.callback = callback
    }
    
    func loadMoreGame(completion: (() -> Void)? = nil){

        
          completion?()
          return
        
    }
    

    func islastItemReached(period:String , index : Int) -> Bool {
        if sectionHeader.count > 0 {
             return period == sectionHeader[sectionHeader.count-1] && index == (games[period]!.count - 1)
        }else {
            return false
        }
     }
     
    func itemAppears(period:String , index : Int) {
        if islastItemReached(period:period , index : index) {
            
            if !noMoreGame {
                print("Load More Game")
                NotificationCenter.default.post(name: .loadMoreGame, object:  nil)
            }
        }
    }
    
}
  

