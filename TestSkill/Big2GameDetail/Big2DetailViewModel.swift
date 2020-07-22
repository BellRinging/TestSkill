import SwiftUI
import FirebaseAuth
import  SwiftEntryKit

class Big2DetailViewModel: ObservableObject {
    
    var game : Game
    var groupUsers : [User]
    var winner : DisplayBoardForBig2?
    var amtPerCard : Int = 10
    var countDouble : Int = 8
    var countTriple : Int = 10
    var countQuadiple : Int = 13
    var enableDouble : Bool = false
    var enableTriple : Bool = false
    var enableQuadiple : Bool = false
    var markBig2 : Bool = false
    var startMinusOne : Bool = false
    @Published var lastGameDetail : Big2GameDetail?
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    
    var filteredDisplayBoard : [DisplayBoardForBig2]? = []
    @Published var showSwapPlayer = false
    @Published var showAlert = false
    @Published var displayBoard : [DisplayBoardForBig2]  = []
    
    init(game:Game,lastGameDetail:Big2GameDetail?){
        self.game = game
        self.lastGameDetail = lastGameDetail
        self.groupUsers = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser)!
        let playGroup = UserDefaults.standard.retrieve(object: PlayGroup.self, fromKey: UserDefaultsKey.CurrentGroup)!
        self.countDouble = playGroup.double
        self.countTriple = playGroup.triple
        self.countQuadiple = playGroup.quadiple
        self.enableDouble = playGroup.enableDouble  == 1
        self.enableTriple = playGroup.enableTriple  == 1
        self.enableQuadiple = playGroup.enableQuadiple  == 1
        self.startMinusOne = playGroup.startMinusOne == 1
        self.markBig2 = playGroup.markBig2 == 1
        self.amtPerCard = playGroup.big2Amt
        convertResultToDisplay()
        self.loadLastGameRecord()
    }
    
    func saveDetail(whoWin : String ,actualNum : [String:Int],refValue : [String:Int],multipler : [String:Int] ,whoBig2 : String?){
        Utility.showProgress()
        let detailNo = game.detailCount + 1
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        let datetime = formatter.string(from: Date())
        let period = self.game.period
        let gameId = self.game.id
        let uuid = UUID().uuidString
        let uid = Auth.auth().currentUser!.uid
        let big2Detail = Big2GameDetail(id: uuid, gameId: gameId, winnerId: whoWin, whoBig2:whoBig2,actualNum: actualNum, refValue: refValue, multipler: multipler, period: period, createDateTime: datetime, detailNo: detailNo,playerId:self.game.playersId)
        big2Detail.save().then { (detail)  in
            let noLastGame = self.lastGameDetail == nil
            let playerIds = self.game.playersId
            let detailCount = self.game.detailCount
            self.game.detailCount = detailCount + 1
            
            var gameResult = self.game.result
            for (key,value) in gameResult{
                gameResult[key] = value  + refValue[key]!
            }
            self.game.result = gameResult
            
            var totalCards = self.game.totalCards!
            for (key,value) in totalCards{
                totalCards[key] = value  + actualNum[key]! * multipler[key]!
            }
            self.game.totalCards = totalCards
            
            var winCount = self.game.winCount!
            winCount[whoWin] = winCount[whoWin]! + 1
            self.game.winCount = winCount
            
            var whoIsLast = ""
            var whoWinLast = ""
            if (noLastGame == false) {
                whoWinLast = self.lastGameDetail!.winnerId
                var whoWinIndex = playerIds.firstIndex(of: whoWinLast)!
                whoIsLast = playerIds[whoWinIndex-1 > 0 ? whoWinIndex-1 : 2]
            }
            
            var doubleCount = self.game.doubleCount!
            var tripleCount = self.game.tripleCount!
            var quadipleCount = self.game.quadipleCount!
            var doubleBecaseLastCount = self.game.doubleBecaseLastCount!
            let _ = multipler.map {
                if $1 > 1{
                    doubleCount[$0] = doubleCount[$0]! + 1
                    if (whoIsLast == $0) {
                        doubleBecaseLastCount[$0] = doubleBecaseLastCount[$0]! + 1
                    }
                }
                if $1 == 3{
                    tripleCount[$0] = tripleCount[$0]! + 1
                }
                if $1 == 4{
                    quadipleCount[$0] = quadipleCount[$0]! + 1
                }
            }
            self.game.doubleCount = doubleCount
            self.game.tripleCount = tripleCount
            self.game.doubleBecaseLastCount = doubleBecaseLastCount
            self.game.quadipleCount = quadipleCount
            
            var safeGameCount = self.game.safeGameCount!
            var lostStupidCount = self.game.lostStupidCount!
            for playerId in playerIds{
                let big2Check = whoBig2 == playerId;
                let lastGameCheck = whoWinLast == playerId;
                let doubeCheck = multipler[playerId]! > 1 ;
                if (big2Check || lastGameCheck){
                    safeGameCount[playerId] = safeGameCount[playerId]! + 1
                }
                if ((big2Check || lastGameCheck) && doubeCheck){
                    lostStupidCount[playerId] = lostStupidCount[playerId]! + 1
                }
            }
            self.game.safeGameCount = safeGameCount
            self.game.lostStupidCount = lostStupidCount
             
            let year = Int(period.prefix(4))!
            let updateAmount = (year,refValue[uid]!)
            NotificationCenter.default.post(name: .updateUserBalance, object:  updateAmount)
            NotificationCenter.default.post(name: .updateLastBig2GameRecord, object:  big2Detail)
            NotificationCenter.default.post(name: .updateGame, object:  self.game)
        }.catch { (error) in
            Utility.showAlert(message: error.localizedDescription)
        }
        }
     func eat(_ who:Int){
         winner = self.displayBoard[who]
         filteredDisplayBoard = self.displayBoard.filter{$0.id != self.displayBoard[who].id}
         let popup = Big2DetailPopUp(viewModel: self)
         let customView = UIHostingController(rootView: popup)
         var attributes = EKAttributes()
         attributes.windowLevel = .normal
         attributes.position = .center
         attributes.displayDuration = .infinity
         attributes.screenInteraction = .forward
         attributes.entryInteraction = .forward
         attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
         attributes.positionConstraints.size = .init(width: .offset(value: 50), height: .intrinsic)
         let edgeWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
         attributes.positionConstraints.maxSize = .init(width: .constant(value: edgeWidth), height: .intrinsic)
         attributes.roundCorners = .all(radius: 10)
         SwiftEntryKit.display(entry: customView, using: attributes)
     }
    
    func rollback(){
        if let lastRecord = lastGameDetail {
            let uid = Auth.auth().currentUser!.uid
            let detailCount = self.game.detailCount
            self.game.detailCount = detailCount - 1
             lastRecord.delete().then {
                return Big2GameDetail.getLastDetailByGameId(gameId: self.game.id, detailNo: detailCount)
             }.then {(lastLastGame) in
                let noLastGame = lastLastGame == nil
                let refValue = lastRecord.refValue
                let actualNum = lastRecord.actualNum
                let whoWin = lastRecord.winnerId
                let multipler = lastRecord.multipler
                let whoBig2 = lastRecord.whoBig2
                let playerIds = lastRecord.playerId

                var gameResult = self.game.result
                for (key,value) in gameResult{
                    gameResult[key] = value  - refValue[key]!
                }
                self.game.result = gameResult

                var totalCards = self.game.totalCards!
                for (key,value) in totalCards{
                    totalCards[key] = value  - actualNum[key]! * multipler[key]!
                }
                self.game.totalCards = totalCards

                var winCount = self.game.winCount!
                winCount[whoWin] = winCount[whoWin]! - 1
                self.game.winCount = winCount
                
                
                var whoIsLast = ""
                var whoWinLast = ""
                if (noLastGame == false) {
                    whoWinLast = lastLastGame!.winnerId
                    var whoWinIndex = playerIds.firstIndex(of: whoWinLast)!
                    whoIsLast = playerIds[whoWinIndex-1 > 0 ? whoWinIndex-1 : 2]
                }

                var doubleCount = self.game.doubleCount!
                var tripleCount = self.game.tripleCount!
                var quadipleCount = self.game.quadipleCount!
                var doubleBecaseLastCount = self.game.doubleBecaseLastCount!
                let _ = multipler.map {
                    if $1 > 1{
                        doubleCount[$0] = doubleCount[$0]! - 1
                        if (whoIsLast == $0) {
                          doubleBecaseLastCount[$0] = doubleBecaseLastCount[$0]! - 1
                        }
                    }
                    if $1 == 3{
                        tripleCount[$0] = tripleCount[$0]! - 1
                    }
                    if $1 == 4{
                        quadipleCount[$0] = quadipleCount[$0]! - 1
                    }
                }
                self.game.doubleCount = doubleCount
                self.game.tripleCount = tripleCount
                self.game.doubleBecaseLastCount = doubleBecaseLastCount
                self.game.quadipleCount = quadipleCount

                var safeGameCount = self.game.safeGameCount!
                var lostStupidCount = self.game.lostStupidCount!
                for playerId in playerIds{
                    let big2Check = whoBig2 == playerId;
                    let lastGameCheck = whoWinLast == playerId;
                    let doubeCheck = multipler[playerId]! > 1 ;
                    if (big2Check || lastGameCheck){
                        safeGameCount[playerId] = safeGameCount[playerId]! - 1
                    }
                    if ((big2Check || lastGameCheck) && doubeCheck){
                        lostStupidCount[playerId] = lostStupidCount[playerId]! - 1
                    }
                }
                self.game.safeGameCount = safeGameCount
                self.game.lostStupidCount = lostStupidCount

                NotificationCenter.default.post(name: .updateLastBig2GameRecord, object:  lastLastGame)
                NotificationCenter.default.post(name: .updateGame, object:  self.game)
                let year = Int(self.game.period.prefix(4))!
                let updateAmount = (year,refValue[uid]! * -1)
                NotificationCenter.default.post(name: .updateUserBalance, object:  updateAmount)
             }.catch { (err) in
                Utility.showAlert(message: "Error on rollback")
            }
        }else{
            Utility.showAlert(message: "No record to rollback")
        }
    }
    
    
    func loadLastGameRecord(){
        self.background.async {
            if self.game.detailCount == 0 || self.lastGameDetail != nil{
                return
            }
            Big2GameDetail.getLastDetailByGameId(gameId: self.game.id, detailNo: self.game.detailCount).then { (detail) in
                self.lastGameDetail = detail
            }.catch { (err) in
                print("No last game Find")
            }
        }
    }
    
    
    func checkMultiple(num : Int , lastWin: Bool) -> (Int,Int){
        var checkValue = startMinusOne ? num + (lastWin ? 1:0) : num
        var multipler = 1
        if checkValue >= countQuadiple && enableQuadiple {
            multipler = 4
        }else if checkValue >= countTriple && enableTriple {
            multipler = 3
        }else if checkValue >= countDouble && enableDouble {
            multipler = 2
        }
        return (multipler, num * multipler)
    }

    func convertResultToDisplay(){
        var temp : [DisplayBoardForBig2] = []
        var count = 0
        for player in game.playersId{
            let balance = game.result[player] as? Int ?? 0
            let totalCards = game.totalCards![player] as? Int ?? 0
            let winCount = game.winCount![player] as? Int ?? 0
            let doubleCount = game.doubleCount![player] as? Int ?? 0
            let tripleCount = game.tripleCount![player] as? Int ?? 0
            let qurdipleCount = game.quadipleCount![player] as? Int ?? 0
            let doubleBecaseLastCount = game.doubleBecaseLastCount![player] as? Int ?? 0
            let lostStupidCount = game.lostStupidCount![player] as? Int ?? 0
            let safeGameCount = game.safeGameCount![player] as? Int ?? 0
            let name  = game.playersMap[player]
            let user = groupUsers.filter { $0.id == player }.first
            let imgUrl = user!.imgUrl
            let dict : [String : Any] = ["id":player,"name": name! ,"imgUrl": imgUrl,"balance": balance,"totalCards":totalCards,"order": count + 1,
                                         "winCount":winCount,
                                         "doubleCount":doubleCount,
                                         "tripleCount":tripleCount,
                                         "qurdipleCount":qurdipleCount,
                                         "lostStupidCount":lostStupidCount,
                                         "safeGameCount":safeGameCount,
                                         "doubleBecaseLastCount":doubleBecaseLastCount
            ]
            count = count + 1
            let board = DisplayBoardForBig2(dict: dict)
            temp.append(board)
        }
        self.displayBoard = temp
    }
    
    func showListView(){
        
        let popup = Big2DetailListView(game:self.game)
        let customView = UIHostingController(rootView: popup)
        var attributes = EKAttributes()
        attributes.windowLevel = .normal
        attributes.position = .center
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .forward
        attributes.entryInteraction = .forward
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.positionConstraints.size = .init(width: .fill, height: .fill)
        let edgeWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: edgeWidth), height: .intrinsic)
        attributes.roundCorners = .all(radius: 10)
        SwiftEntryKit.display(entry: customView, using: attributes)
    }

}
