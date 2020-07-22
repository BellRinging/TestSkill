import SwiftUI

class SearchGameDetailRowViewModel: ObservableObject {
    
    var date : String = ""
    var location : String = ""
    var win : Bool = false
    var amount : Int = 0
    @Published var players : [User] = []
    @Published var playersResult : [Bool] = []
    @Published var playersAmount : [Int] = []
    var users:[User] = []
//    var gameDetail : GameDetail
    
    var whoWin : [User] = []
    var whoLose : [User] = []
    var winType : String = ""
    var fan : Int = 0
    var refAmount : Int = 0
    var refUser : User?
    var userAmount : [String:Int] = [:]
    var detailNo : Int = 0
    
    
    init(gameDetail:GameDetail ,refUser: User?) {
        self.refUser = refUser
        self.winType = gameDetail.winType
        self.detailNo = gameDetail.detailNo
        for id in gameDetail.playerList.keys{
            self.userAmount[id] = 0
        }
        gameDetail.whoWin.map { (id) in
            let check = self.whoWin.firstIndex{$0.id == id}
        
            if check == nil {
                whoWin.append(Utility.getUserObject(id: id))
            }
            if refUser != nil && id == refUser!.id {
                self.refAmount = self.refAmount + gameDetail.winnerAmount
            }else{
                userAmount[id] = userAmount[id]! + gameDetail.winnerAmount
            }
        }
        gameDetail.whoLose.map { (id) in
            let check = self.whoLose.firstIndex{$0.id == id}
//            print(check)
            if check == nil {
                whoLose.append(Utility.getUserObject(id: id))
            }
            
            if refUser != nil && id == refUser!.id {
                self.refAmount = self.refAmount + gameDetail.loserAmount
            }else{
                userAmount[id] = userAmount[id]! + gameDetail.loserAmount
            }
        }
        self.fan = gameDetail.fan
//        print("final \(self.refAmount)")
    }
    
    
    
   
}
