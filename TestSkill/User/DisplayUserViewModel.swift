import SwiftUI
import FirebaseAuth

class DisplayUserViewModel: ObservableObject {

    @Published var users : [User] = []
    @Published var selectedUser : [User] = []
    @Binding var closeFlag : Bool
    @Binding var players : [User]
    var maxSelection : Int
    
    
    init(flag : Binding<Bool> , users : Binding<[User]>, maxSelection : Int){
        selectedUser = []
        self._closeFlag = flag
        self._players = users
        self.selectedUser = users.wrappedValue
        self.maxSelection = maxSelection
        print("selected user count \(selectedUser.count)")
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
    
    func loadUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        User.getAllItem().then { (users)  in
            let filter = users.filter{ (user) in
                if user.id == uid {
                    if !self.selectedUser.contains(user){
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
