
import Foundation
import SwiftUI


class GameViewListAreaViewModel: ObservableObject {

    
    var groupUsers : [User]
    var sectionHeader : [String]
    var sectionHeaderAmt : [String:Int]
    var games : [String:[Game]]
    var status : pageStatus
    var callback : (String,Int) -> ()
    var selectedPeriod : String = ""
    var selectedIndex : Int = 0
    @Published var showingDeleteAlert = false
    @Published var showingFlowView = false
    @Published var isShowing = false
    var lastGameDetail : GameDetail?
    var lastBig2GameDetail : Big2GameDetail?
    var gameForFlown : Game?
    
    init(groupUsers:[User],sectionHeader: [String],sectionHeaderAmt: [String:Int],games:[String:[Game]],status: pageStatus,lastGameDetail:GameDetail?,callback : @escaping (String,Int) -> () ){
        
//        print("inside ListArea \(lastGameDetail)")
        self.groupUsers = groupUsers
        self.sectionHeader = sectionHeader
        self.sectionHeaderAmt = sectionHeaderAmt
        self.games = games
        self.status = status
        self.lastGameDetail = lastGameDetail
        self.callback = callback
    }

    
    
}
  

