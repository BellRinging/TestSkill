import SwiftUI
import FirebaseAuth

class DisplayFriendViewModel: ObservableObject {

    @Published var users : [User] = []
    @Published var selectedUser : [User] = []
    @Binding var closeFlag : Bool
    @Binding var players : [User]
    var maxSelection : Int
    var includeSelf : Bool
    
    
    init(flag : Binding<Bool> , users : Binding<[User]>, maxSelection : Int ,includeSelf: Bool){
        selectedUser = []
        self._closeFlag = flag
        self._players = users
        self.selectedUser = users.wrappedValue
        self.maxSelection = maxSelection
        self.includeSelf = includeSelf
        self.loadUser()
    }
    
    func addToSelectedList(user : User){
         if let index = selectedUser.firstIndex(of:user){
             selectedUser.remove(at: index)
         }else{
            if selectedUser.count < maxSelection {
                selectedUser.append(user)
            }
         }
     }
    
    func confirm(){
        if self.includeSelf {
            if let yourself = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser){
                self.selectedUser.append(yourself)
            }
        }
        self.players = self.selectedUser
        self.closeFlag.toggle()
    }
    
    func loadUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        User.getAllItem().then { [unowned self] (users)  in
            let filter = users.filter{ (user) in
                if user.id == uid {
                    if !self.selectedUser.contains(user) && self.includeSelf{
                        self.selectedUser.append(user)
                    }
                }
                return user.id != uid
            }
            self.users = filter
        }.catch({ (err) in
            Utility.showError(message: err.localizedDescription)
        })
    }
}
