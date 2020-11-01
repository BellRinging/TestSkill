import SwiftUI
import FirebaseAuth
import  SwiftEntryKit

class GameDetailViewModel: ObservableObject {

    @Binding var game : Game{
        didSet{
//            print("didset gameDetail")
            self.convertResultToDisplay()
        }
    }
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
    @Published var enableSpecialItem : Bool = true
    @Published var enableBonusPerDraw : Bool = true
    @Published var enableCalimWater : Bool = true
    @Published var detailCount : Int = 0
    @Published var bonus : Int? = 0
    @Published var water : Int? = 0
    var calimWaterAmount : Int = 0
    var calimWaterFan : Int = 0
    var specialItemAmount : Int = 0
    var bonusPerDraw : Int = 0
    var lastGameWin : [User] = []
    var lastGameLose : [User] = []
    var lastGameType : String = ""
    var lastGameFan : Int = 0
    var owner : String = ""
    
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
    
    @Published var showSpecialView : Bool = false
    @Published var displayBoard : [DisplayBoard] = []
    
    init(game : Binding<Game> ){
        self._game = game
//        print("init Game Detail Model")
        self.groupUsers = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser)!
        let ownerObj = groupUsers.filter{$0.id == game.wrappedValue.owner}.first!
        self.owner = ownerObj.userName
        self.loadLastGameRecord()
    }

    
    func fromCurrentGroup(){
        let curGroup = UserDefaults.standard.retrieve(object: PlayGroup.self, fromKey: UserDefaultsKey.CurrentGroup) as! PlayGroup
        group = curGroup
        self.startFan = curGroup.startFan
        self.endFan = curGroup.endFan
        
        self.enableSpecialItem = curGroup.enableSpecialItem == 1
        self.enableBonusPerDraw = curGroup.enableBonusPerDraw  == 1
        self.enableCalimWater = curGroup.enableCalimWater  == 1
        self.calimWaterAmount = curGroup.calimWaterAmount
        self.calimWaterFan = curGroup.calimWaterFan
        self.specialItemAmount = curGroup.specialItemAmount
        self.bonusPerDraw = curGroup.bonusPerDraw
        
        
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
        for player in game.playersId{
            let balance = game.result[player] as? Int ?? 0
            let name  = game.playersMap[player]
            let user = groupUsers.filter { $0.id == player }.first
            let imgUrl = user!.imgUrl
            let dict : [String : Any] = ["id":player,"name": name! ,"imgUrl": imgUrl,"balance": balance,"order": count + 1]
            count = count + 1
            let board = DisplayBoard(dict: dict)
            temp.append(board)
        }
        self.status = .completed
        self.displayBoard = temp
        self.detailCount = self.game.detailCount
        self.bonus = self.game.bonus
        self.water = self.game.water
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
        let uid = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!.id
        if uid != self.game.owner{
            Utility.showAlert(message: "Only Owner can mark record")
            return
        }
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
//        print("load last record")
        if self.game.detailCount == 0 {
            self.lastGameDetail = nil
            return
        }
        GameDetail.getLastDetailByGameId(gameId: self.game.id, detailNo: self.game.detailCount).then { (detail) in
            self.lastGameDetail = detail
        }.catch { (err) in
            print("No last game Find")
        }
        
    }
    
    func markDraw(){
        let uid = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!.id
        if uid != self.game.owner{
            Utility.showAlert(message: "Only Owner can mark record")
            return
        }
        Utility.showProgress()
        let detailNo = game.detailCount + 1
        var value = self.bonusPerDraw
        var whoLoseList:[String] = self.game.playersId
        var whoWinList:[String] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        let datetime = formatter.string(from: Date())
        let playersList = self.game.playersMap
        let period = self.game.period
        let uuid = UUID().uuidString
        let winType = "draw"
        let bonus =  value * 4
        let involvedPlayer = self.game.playersId
        let gameDetail = GameDetail(id: uuid, gameId: self.game.id, fan: 0, value: value, winnerAmount: 0, loserAmount: value * -1 , whoLose: whoLoseList, whoWin: whoWinList, winType: winType ,byErrorFlag: 0,repondToLose:0,playerList:playersList,involvedPlayer: involvedPlayer, period:period,createDateTime:datetime,detailNo: detailNo,bonusFlag: 0 , bonus: bonus,waterFlag: 0,waterAmount: 0)
        gameDetail.save().then { (gameDetail)  in
            self.lastGameDetail = gameDetail
            let uid = Auth.auth().currentUser!.uid
            var tempGame = self.game
            whoLoseList.map { (loser)  in
                let amount = self.game.result[loser]! - value
                tempGame.result[loser]! = amount
            }
            let detailCount = self.game.detailCount
            tempGame.detailCount = detailCount + 1
            tempGame.bonusFlag = 1
            tempGame.bonus = (self.game.bonus ?? 0 ) + value * 4
            
            let year = Int(period.prefix(4))!
            NotificationCenter.default.post(name: .updateUserBalance, object:  (year,value * -1))
            self.game = tempGame
        }.catch { (error) in
            Utility.showAlert(message: error.localizedDescription)
        }
    }
    
    func rollback(){
        let uid = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!.id
        if uid != self.game.owner{
            Utility.showAlert(message: "Only Owner can mark record")
            return
        }
        if self.lastGameDetail == nil {
            Utility.showAlert(message: "No last record")
            return
        }
        Utility.showProgress()
        if let lastRecord = self.lastGameDetail {
            let uid = Auth.auth().currentUser!.uid
            var needUpdateBalance = false
            var updateAmount = 0
            var result = self.game.result
            let winAmt = lastRecord.winnerAmount
            let loserAmt = lastRecord.loserAmount
            let winType = lastRecord.winType
            let bonusFlag = lastRecord.bonusFlag ?? 0
            let waterFlag = lastRecord.waterFlag ?? 0
            let waterAmount = lastRecord.waterAmount ?? 0
            let year = Int(self.game.period.prefix(4))!
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
                var tempGame = self.game
                tempGame.detailCount = self.game.detailCount - 1
                if winType == "draw"{
                    let bonus = (self.game.bonus ?? 0) + loserAmt * 4
//                    print("===== \(bonus)")
                    if bonus == 0 {
                        tempGame.bonusFlag = 0
                        tempGame.bonus = 0
                    }else{
                        tempGame.bonusFlag = 1
                        tempGame.bonus = bonus
                    }
                }
                if waterFlag == 1 {
                    tempGame.water = self.game.water! - waterAmount
                }
                if bonusFlag == 1 {
                    let bonus = lastRecord.bonus
                    tempGame.bonusFlag = 1
                    tempGame.bonus = bonus
                }
                tempGame.result = result
                                
                if (needUpdateBalance){
                    let temp = (year ,updateAmount)
               
                    NotificationCenter.default.post(name: .updateUserBalance, object:  temp)
                }
                self.game = tempGame
                self.loadLastGameRecord()
            }
        }else{
            print("no last record")
        }
        Utility.hideProgress()
    }
    
    func saveDetail( p : gameDetailPassing ){
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
        let bonus = self.game.bonus ?? 0
        let bonusFlag = self.game.bonusFlag ?? 0
        var getTheBonusFlag = 0
        let uuid = UUID().uuidString
        
        
        if (p.winType == "Self" || p.byErrorFlag == 1){
            self.filteredDisplayBoard.map { user in
                whoLoseList.append(user.id)
            }
            whoWinList = [p.whoWin]
            value = self.ruleSelf[p.fan] ?? 0
            winnerAmount = value * 3
            loserAmount = value * -1
            if (p.byErrorFlag == 1){
                //swap the item
                let temp = whoWinList
                whoWinList = whoLoseList
                whoLoseList = temp
                let tem2 = winnerAmount
                winnerAmount = loserAmount
                loserAmount = tem2
            }
        }else{
            whoWinList = [p.whoWin]
            whoLoseList = [p.whoLose]
            value = p.loserRespond == 1 ? (self.ruleSelf[p.fan] ?? 0 ) * 3 : (self.rule[p.fan] ?? 0)
            winnerAmount = value
            loserAmount = value * -1
        }
    
        
        if winnerAmount == ruleSelf[endFan]! * 3  && self.game.bonusFlag == 1 {
            winnerAmount = winnerAmount + bonus
            getTheBonusFlag = 1
        }
        let waterFlag = enableCalimWater && calimWaterFan <= p.fan ? 1:0
        if waterFlag == 1 {
            winnerAmount = winnerAmount - calimWaterAmount
        }
        var involvedPlayer = whoWinList
        involvedPlayer.append(contentsOf: whoLoseList)
        let gameDetail = GameDetail(id: uuid, gameId: self.game.id, fan: p.fan, value: value, winnerAmount: winnerAmount, loserAmount: loserAmount, whoLose: whoLoseList, whoWin: whoWinList, winType: p.winType ,byErrorFlag: p.byErrorFlag,repondToLose:p.loserRespond,playerList:playersList,involvedPlayer:involvedPlayer, period:period,createDateTime:datetime,detailNo: detailNo,bonusFlag: getTheBonusFlag,bonus: bonus,waterFlag: waterFlag,waterAmount: calimWaterAmount)
        
        var tempGame = self.game
        gameDetail.save().then { (gameDetail)  in
            self.lastGameDetail = gameDetail
            if getTheBonusFlag == 1 {
                tempGame.bonusFlag = 0
                tempGame.bonus = 0
            }

            let uid = Auth.auth().currentUser!.uid
            var needUpdateBalance = false
            var updateAmount = 0
            whoWinList.map { (winner)  in
                let amount = self.game.result[winner]! + winnerAmount   * (p.byErrorFlag == 1 ? -1:1)
                if winner == uid {
                    needUpdateBalance = true
                    updateAmount = winnerAmount   * (p.byErrorFlag == 1 ? -1:1)
                }
                tempGame.result[winner]! = amount
            }
            whoLoseList.map { (loser)  in
                let amount = self.game.result[loser]! + loserAmount * (p.byErrorFlag == 1 ? -1:1)
                if loser == uid {
                    needUpdateBalance = true
                    updateAmount = loserAmount * (p.byErrorFlag == 1 ? -1:1)
                }
                tempGame.result[loser]! = amount
            }
            
            if waterFlag == 1 {
                tempGame.water = (self.game.water ?? 0) + self.calimWaterAmount
            }
            let detailCount = self.game.detailCount
            tempGame.detailCount = detailCount + 1
            print("detailCount",tempGame.detailCount)
            if (needUpdateBalance){
                let year = Int(self.game.period.prefix(4))!
                let temp = (year,updateAmount)
                NotificationCenter.default.post(name: .updateUserBalance, object:  temp)
            }
            self.game = tempGame
            print(self.game.detailCount)
            
        }.catch { (error) in
            Utility.showAlert(message: error.localizedDescription)
        }
    }
    
   
}

