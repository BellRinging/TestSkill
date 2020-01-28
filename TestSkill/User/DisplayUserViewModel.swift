import SwiftUI
import FirebaseAuth

class DisplayUserViewModel: ObservableObject {

    init(){
        selectedUser = []
        loadUser()
    }
    
    @Published var users : [User] = []
    weak var parent : AddPlayGroupViewModel?{
        didSet{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // your code here
                print("inside timer")
                let parentSelectedUser = self.parent!.players
                print("Parent count \(parentSelectedUser.count)")
                for user in parentSelectedUser {
                    if !self.selectedUser.contains(user){
                        self.selectedUser.append(user)
                    }
                }
            }
//            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
//            }
        }
    }
    @Published var selectedUser : [User] = []
    
    
    func loadUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Utility.showProgress()
        User.getAllItem().then { (users)  in
            let filter = users.filter{ (user) in
                if user.id == uid {
                    self.selectedUser.append(user)
                }
                return user.id != uid
            }
            self.users = filter
        }.catch({ (err) in
            Utility.showError(message: err.localizedDescription)
        }).always {
            Utility.hideProgress()
        }
    }
    

}
