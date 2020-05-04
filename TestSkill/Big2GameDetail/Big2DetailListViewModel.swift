import SwiftUI
import FirebaseAuth
import  SwiftEntryKit

class Big2DetailListViewModel: ObservableObject {
    
    var rule : [Int:Int] = [8:2, 10:3 , 13:4]
    @Published var history : [[Int]] = []
    @Published var leftHistory : [[Int]] = []
    @Published var showAccumulateValue : Bool = false
    var multiplers : [[Int]] = []
    @Published var accumulateValue : [[Int]] = []
    var itemColor : [[Color]] = []
    var leftItemColor : [[Color]] = []
    var fontColor : [[Color]] = []
    var leftFontColor : [[Color]] = []
    
    var game : Game
    @Published var user : [User] = []
    var gameDetails : [Big2GameDetail] = [] {
        didSet{
            covertList(gameDetails)
        }
    }
    
    func covertList(_ gameDetails : [Big2GameDetail] ){
        let playerId = game.playersId
        user = []
        let groupsUser = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser)!
        for id in playerId {
            user.append(groupsUser.filter{$0.id == id }.first!)
        }
        var accumlateLine = [0,0,0,0]
        gameDetails.map{
            let multLine = [$0.multipler[playerId[0]]!,$0.multipler[playerId[1]]!,$0.multipler[playerId[2]]!,$0.multipler[playerId[3]]!]
            let actLine = [$0.actualNum[playerId[0]]!,$0.actualNum[playerId[1]]!,$0.actualNum[playerId[2]]!,$0.actualNum[playerId[3]]!]
            let refLine = [$0.refValue[playerId[0]]!/10,$0.refValue[playerId[1]]!/10,$0.refValue[playerId[2]]!/10,$0.refValue[playerId[3]]!/10]
       
            for index in 0...3 {
                accumlateLine[index] = accumlateLine[index] + actLine[index]
            }
            
//            print(refLine)
            var fontColorLine : [Color] = []
            for i in multLine{
                if i == 1 || i == 2{
                    fontColorLine.append(Color.black)
                }else{
                    fontColorLine.append(Color.white)
                }
            }
            var itemColorLine : [Color] = []
            for i in multLine{
                if i == 1{
                    itemColorLine.append(Color.clear)
                }else if i == 2{
                    itemColorLine.append(Color.pink)
                }else  if i == 3{
                    itemColorLine.append(Color.init(red: 119/255, green: 14/255, blue: 18/255))
                }else{
                    itemColorLine.append(Color.black)
                }
            }
            
            var leftItemColorLine : [Color] = []
            for num in refLine{
                if num > 50 {
                    leftItemColorLine.append( Color.init(red: 102/255, green: 145/255, blue: 61/255))
                }else if num > 0  {
                    leftItemColorLine.append( Color.init(red: 132/255, green: 182/255, blue: 78/255))
                }else if num > -20 {
                    leftItemColorLine.append( Color.init(red: 255/255, green: 200/255, blue: 200/255))
                }else if num > -50{
                    leftItemColorLine.append( Color.init(red: 238/255, green: 48/255, blue: 79/255))
                }else  if num >= -100{
                    leftItemColorLine.append( Color.init(red: 119/255, green: 14/255, blue: 18/255))
                }else{
                    leftItemColorLine.append( Color.black)
                }
            }
            
            var leftFontColorLine : [Color] = []
            for num in refLine{
                if num > -20 {
                    leftFontColorLine.append( Color.black)
                }else{
                    leftFontColorLine.append( Color.white)
                }
            }

            history.append(actLine)
            leftHistory.append(refLine)
            leftFontColor.append(leftFontColorLine)
            fontColor.append(fontColorLine)
            leftItemColor.append(leftItemColorLine)
            itemColor.append(itemColorLine)
            accumulateValue.append(accumlateLine)
        }
//        print(leftHistory)
        
    }
   
    init(game:Game){
        self.game = game
        
        loadGameDetail()
    }
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    func loadGameDetail(){
        self.background.async {
            Big2GameDetail.getAllItemById(gameId: self.game.id).then{ gameDetail in
                DispatchQueue.main.async {
                    self.gameDetails = gameDetail
                    print(self.gameDetails.count)
                }
            }.catch { (error) in
                print(error.localizedDescription)
                Utility.showAlert(message: error.localizedDescription)
            }
        }
     }

}
