import SwiftUI
import FirebaseAuth
import  SwiftEntryKit

class GameDetailViewModel: ObservableObject {

    @Published var game : Game
    @Published var status : pageStatus = .loading
    
    @Published var showAlert : Bool = false
    
    var groupUsers : [User]
    var whoWin : Int = 0
    var winner : DisplayBoard?
    var filteredDisplayBoard : [DisplayBoard] = []
    var group : PlayGroup = PlayGroup()
    var startFan : Int = 0
    var endFan : Int = 0
    var rule : [Int:Int] = [:]
    var ruleSelf : [Int:Int] = [:]
    var seperateLineForFan : Bool = true
    
    
    var lastGameWin : [User] = []
    var lastGameLose : [User] = []
    var lastGameType : String = ""
    var lastGameFan : Int = 0

    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    
    @Published var lastGameDetail : GameDetail?{
        didSet{
            if let detail = lastGameDetail{
                self.lastGameFan = detail.fan
                self.lastGameLose = detail.whoLose.map {self.lookupUser($0)}
                self.lastGameWin = detail.whoWin.map {self.lookupUser($0)}
                self.lastGameType = detail.winType
            }
        }
    }
    
    func lookupUser(_ id : String) -> User{
        return groupUsers.first{ $0.id == id}!
    }
    
    @Published var showDetailView : Bool = false
    
    @Published var showSwapPlayer : Bool = false
    
    
    @Published var displayBoard : [DisplayBoard] = []
    
    init(game : Game , lastGameDetail: GameDetail?){
        self.game = game
        self.groupUsers = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser)!
        self.lastGameDetail = lastGameDetail
        self.loadLastGameRecord()
    }

    
    func fromCurrentGroup(){
        let curGroup = UserDefaults.standard.retrieve(object: PlayGroup.self, fromKey: UserDefaultsKey.CurrentGroup) as! PlayGroup
        group = curGroup
        self.startFan = curGroup.startFan
        self.endFan = curGroup.endFan
        if(curGroup.endFan - curGroup.startFan > 4){
            seperateLineForFan = true
        }else{
            seperateLineForFan = false
        }
        for i in curGroup.startFan...curGroup.endFan {
            self.rule[i] = Int( curGroup.rule[i] ?? 0)
            self.ruleSelf[i] = Int(curGroup.ruleSelf[i] ?? 0)
        }
    }

    func convertResultToDisplay(){
        var temp : [DisplayBoard] = []
        var count = 0
        
//           print(game.playersId)
//        print(groupUsers.map{$0.id})
        for player in game.playersId{
            let balance = game.result[player] as? Int ?? 0
            let name  = game.playersMap[player]
            let user = groupUsers.filter { $0.id == player }.first
//            print(user)
            let imgUrl = user!.imgUrl
            let dict : [String : Any] = ["id":player,"name": name! ,"imgUrl": imgUrl,"balance": balance,"order": count + 1]
            count = count + 1
            let board = DisplayBoard(dict: dict)
            temp.append(board)
        }
        self.status = .completed
        self.displayBoard = temp
    }
    
    func onInitial(){
        convertResultToDisplay()
        fromCurrentGroup()
    }
    
      
    
    func showListView(){
           
           let popup = GameDetailListView(game: self.game)
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
       
    

    func eat(_ who:Int){
        
   
        whoWin = who
        winner = self.displayBoard[who]
        filteredDisplayBoard = self.displayBoard.filter{$0.id != self.displayBoard[who].id}
        let popup = GameDetailPopUp(viewModel: self)
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
    
    func loadLastGameRecord(){
        self.background.async {
            if self.game.detailCount == 0 || self.lastGameDetail != nil{
                return
            }
            GameDetail.getLastDetailByGameId(gameId: self.game.id, detailNo: self.game.detailCount).then { (detail) in
                self.lastGameDetail = detail
            }.catch { (err) in
                print("No last game Find")
            }
        }
    }
    
    func rollback(){
        Utility.showProgress()
        if let lastRecord = self.lastGameDetail {
            let uid = Auth.auth().currentUser!.uid
            var needUpdateBalance = false
            var updateAmount = 0
            var result = self.game.result
            let winAmt = lastRecord.winnerAmount
            let loserAmt = lastRecord.loserAmount
            lastRecord.whoWin.map {
                if $0 == uid {
                    needUpdateBalance = true
                    updateAmount = winAmt   * (lastRecord.byErrorFlag == 1 ? 1:-1)
                }
                result[$0]! = result[$0]! - winAmt * (lastRecord.byErrorFlag == 1 ? -1:1)
            }
            lastRecord.whoLose.map {
                if $0 == uid {
                    needUpdateBalance = true
                    updateAmount = loserAmt   * (lastRecord.byErrorFlag == 1 ? 1:-1)
                }
                result[$0]! = result[$0]! - loserAmt * (lastRecord.byErrorFlag == 1 ? -1:1)
            }
            lastRecord.delete().then { _ in
                self.game.detailCount = self.game.detailCount - 1
                self.game.result = result
                                
                if (needUpdateBalance){
                    NotificationCenter.default.post(name: .updateUserBalance, object:  updateAmount)
                }
                NotificationCenter.default.post(name: .updateLastGameRecord, object:  nil)
                NotificationCenter.default.post(name: .updateGame, object:  self.game)
            }
        }else{
            print("no last record")
        }
    }
    
    func saveDetail(whoWin : String ,whoLose : String , winType : String , fan : Int ,loserRespond : Int ,byErrorFlag : Int ){
             Utility.showProgress()
        let detailNo = game.detailCount + 1
        var value = 0
        var whoLoseList:[String] = []
        var whoWinList:[String] = []
        var winnerAmount = 0
        var loserAmount = 0
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        let datetime = formatter.string(from: Date())
        let playersList = self.game.playersMap
        let period = self.game.period
        if (winType == "Self" || byErrorFlag == 1){
            self.filteredDisplayBoard.map { user in
                whoLoseList.append(user.id)
            }
            whoWinList = [whoWin]
            value = self.ruleSelf[fan] ?? 0
            winnerAmount = value * 3
            loserAmount = value * -1
            if (byErrorFlag == 1){
                //swap the item
                let temp = whoWinList
                whoWinList = whoLoseList
                whoLoseList = temp
                let tem2 = winnerAmount
                winnerAmount = loserAmount
                loserAmount = tem2
            }
        }else{
            whoWinList = [whoWin]
            whoLoseList = [whoLose]
//            print(loserRespond)
            value = loserRespond == 1 ? (self.ruleSelf[fan] ?? 0 ) * 3 : (self.rule[fan] ?? 0)
            winnerAmount = value
            loserAmount = value * -1
        }
        let uuid = UUID().uuidString
        let gameDetail = GameDetail(id: uuid, gameId: self.game.id, fan: fan, value: value, winnerAmount: winnerAmount, loserAmount: loserAmount, whoLose: whoLoseList, whoWin: whoWinList, winType: winType ,byErrorFlag: byErrorFlag,repondToLose:loserRespond,playerList:playersList,period:period,createDateTime:datetime,detailNo: detailNo)
        gameDetail.save().then { (gameDetail)  in
            let uid = Auth.auth().currentUser!.uid
            var needUpdateBalance = false
            var updateAmount = 0
            whoWinList.map { (winner)  in
                let amount = self.game.result[winner]! + winnerAmount   * (byErrorFlag == 1 ? -1:1)
                if winner == uid {
                    needUpdateBalance = true
                    updateAmount = winnerAmount   * (byErrorFlag == 1 ? -1:1)
                }
                self.game.result[winner]! = amount
            }
            whoLoseList.map { (loser)  in
                let amount = self.game.result[loser]! + loserAmount * (byErrorFlag == 1 ? -1:1)
                if loser == uid {
                    needUpdateBalance = true
                    updateAmount = loserAmount * (byErrorFlag == 1 ? -1:1)
                }
                self.game.result[loser]! = amount
            }
            let detailCount = self.game.detailCount
            self.game.detailCount = detailCount + 1
            if (needUpdateBalance){
                NotificationCenter.default.post(name: .updateUserBalance, object:  updateAmount)
            }
            NotificationCenter.default.post(name: .updateLastGameRecord, object:  gameDetail)
            NotificationCenter.default.post(name: .updateGame, object:  self.game)
        }.catch { (error) in
            Utility.showAlert(message: error.localizedDescription)
        }
    }
    
}
