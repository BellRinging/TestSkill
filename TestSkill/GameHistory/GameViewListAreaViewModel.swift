
import Foundation
import SwiftUI
import Combine


class GameViewListAreaViewModel: ObservableObject {

    
    var groupUsers : [User]
    @Binding var games : GameList
    var selectedGame : Game? = nil
    var gameForFlown : Game?
    @Published var showingDeleteAlert = false
    @Published var showingFlowView = false
    @Published var isShowing = false

    
    init(
         games: Binding<GameList>){
        self.groupUsers = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser) ?? []
        self._games = games
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
            if !self.games.noMoreGame {
                print("Load More Game")
                NotificationCenter.default.post(name: .loadMoreGame, object:  nil)
            }
        }
    }
    
}
  

