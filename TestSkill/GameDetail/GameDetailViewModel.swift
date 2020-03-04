import SwiftUI
import FirebaseAuth
import  SwiftEntryKit

class GameDetailViewModel: ObservableObject {

    @Published var game : Game
    @Published var status : pageStatus = .loading
    
    var users : [User]
    var whoWin : Int = 0
    var winner : DisplayBoard?
    var filteredDisplayBoard : [DisplayBoard] = []
    var group : PlayGroup = PlayGroup()
    var startFan : Int = 0
    var endFan : Int = 0
    var rule : [Int:Int] = [:]
    var ruleSelf : [Int:Int] = [:]
    var seperateLineForFan : Bool = true
    
    @Published var displayBoard : [DisplayBoard] = []
    
    init(game : Game ,users : [User]){
        self.game = game
        self.users = users
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
            self.ruleSelf[i] = Int(curGroup.rule[i*10] ?? 0)
        }
    }
    
    func convertResultToDisplay(){
        var temp : [DisplayBoard] = []
        for player in game.playersId{
            let balance = game.result[player] as? Int ?? 0
            let name  = game.playersMap[player]
            let user = users.filter { $0.id == player }.first
            let imgUrl = user!.imgUrl
            let dict : [String : Any] = ["id":player,"name": name! ,"imgUrl": imgUrl,"balance": balance]
            let board = DisplayBoard(dict: dict)
            temp.append(board)
        }
        self.status = .completed
        self.displayBoard = temp
    }
    
    func onInitial(){
//        print(game.result)
        convertResultToDisplay()
        fromCurrentGroup()
    }
    
    func getUserFrom(uid : String){
        
    }
    

    func eat(_ who:Int){
        //        print("\(self.displayBoard[who].user_name) 食糊啦")
        whoWin = who
        winner = self.displayBoard[who]
        
        filteredDisplayBoard = self.displayBoard.filter{$0.id != self.displayBoard[who].id}
        // Customized view
        let customView = UIHostingController(rootView: GameDetailPopUp(viewModel: self))
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
    
}
