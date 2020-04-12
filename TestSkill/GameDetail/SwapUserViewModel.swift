import SwiftUI
import FirebaseAuth
import  SwiftEntryKit

class SwapUserViewModel: ObservableObject {

    @Published var users : [User] = []
    var text : [String] = ["東","南","西","北"]
    var groupUsers : [User]
    var game : Game
    var result : [String]
    @Binding var closeFlag : Bool
    
    init(game:Game,closeFlag:Binding<Bool>){
        self.game = game
        self.result = game.playersId
        self._closeFlag = closeFlag
        let usersId = game.playersId
        self.groupUsers = []
        if let usergroup = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser) {
            self.groupUsers = usergroup
        }else{
            Utility.showAlert(message: "Fail to get the user Group")
        }
        setupUsers(list:usersId)
    }

    func setupUsers(list :[String]){
        self.users = list.map{ self.lookupUser($0) }
    }
    
    func lookupUser(_ id : String) -> User{
        return groupUsers.filter{$0.id == id}.first!
    }
    
    func move(source:IndexSet,destination:Int){
        users.move(fromOffsets: source, toOffset: destination)
        result = users.map{$0.id}
    }
    
    func swap(){
        self.closeFlag = false
        if result == self.game.playersId {
            print("no order change")
            return
        }
        self.game.updatePlayerOrder()
        self.game.playersId = result
        NotificationCenter.default.post(name: .updateGame, object:  self.game)
    }
    
}
