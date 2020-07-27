
import Foundation
import SwiftUI
import Combine


class GameViewListAreaViewModel: ObservableObject {

    
    var groupUsers : [User]
    var games : GameList
    var status : pageStatus
    var selectedGame : Game? = nil
    var lastGameDetail : GameDetail?
    var lastBig2GameDetail : Big2GameDetail?
    var gameForFlown : Game?
    @Published var showingDeleteAlert = false
    @Published var showingFlowView = false
    @Published var isShowing = false
    @Published var isLoading = false
    var noMoreGame = false
    
    
    init(
         games: GameList,
         status: pageStatus,
         lastGameDetail:GameDetail?,
          noMoreGame:Bool){
        self.groupUsers = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser)!
        self.games = games
        self.status = status
        self.lastGameDetail = lastGameDetail
        self.noMoreGame = noMoreGame
    }
    

    func islastItemReached(game:Game) -> Bool {
        if self.games.list.count > 0 {
            return game.id == self.games.list.last!.games.last!.id
        }else {
            return false
        }
     }
    func itemAppears(game:Game) {
        if islastItemReached(game:game) {
            if !noMoreGame {
                print("Load More Game")
                NotificationCenter.default.post(name: .loadMoreGame, object:  nil)
            }
        }
    }
    
}
  

