import SwiftUI
import FirebaseAuth
import  SwiftEntryKit

class GameDetailListViewModel: ObservableObject {
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    var game : Game
    @Published var gameForDisplay : [[String]] = []
    var users : [User]
    var totals : [Int] = []
    var gameDetail : [GameDetail]? {
        didSet{
//            print("Did Set in detail list")
            convertDisplay(gameDetail!)
        }
    }
    
    init(game:Game){
        print("init Detail List View")
        self.game = game
        self.users = []
        if let groupUsers = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser) {
            self.users = game.playersId.map{
                self.resolveUser($0, list: groupUsers)!
            }
        }
        gameForDisplay = []
    }
    
    func resolveUser(_ uid : String,list:[User]) -> User? {
        return list.filter{$0.id == uid}.first
    }
    
    func convertUserName(_ playerId : [String]) -> [String]{
        return playerId.map{self.game.playersMap[$0]!}
    }
    
    func convertDisplay(_ gameDetails : [GameDetail]){
        var forDisplay : [[String]] = []
//          print("original : \(forDisplay.count)")
        let players = self.game.playersId
    
        var player1 : Int = 0
        var player2 : Int = 0
        var player3 : Int = 0
        var player4 : Int = 0
        
        for detail in gameDetails{
            var result : [String] = ["0","0","0","0"]
            for win in detail.whoWin{
                let index = players.firstIndex{$0 == win}!
                result[index] = "\(detail.winnerAmount)"
            }
            for loser in detail.whoLose{
                let index = players.firstIndex{$0 == loser}!
                result[index] = "\(detail.loserAmount)"
            }
            forDisplay.append(result)
            player1 = player1 + Int(result[0])!
            player2 = player2 + Int(result[1])!
            player3 = player3 + Int(result[2])!
            player4 = player4 + Int(result[3])!
        }
        totals.append(player1)
        totals.append(player2)
        totals.append(player3)
        totals.append(player4)

        self.gameForDisplay = forDisplay
    }
   
    func loadGameDetail(){
        self.background.async {
            GameDetail.getAllItemById(gameId: self.game.id).then{ gameDetail in
                DispatchQueue.main.async {
                    self.gameDetail = gameDetail
                }
            }.catch { (error) in
                print(error.localizedDescription)
                Utility.showAlert(message: error.localizedDescription)
            }
        }
     }
}
