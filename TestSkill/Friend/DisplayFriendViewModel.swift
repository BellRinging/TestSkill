import SwiftUI
import FirebaseAuth
import Combine

class DisplayFriendViewModel: ObservableObject {

    @Published var users : [User] = []
    @Published var selectedUser : [User] = []
    @Published var showAddFriend : Bool = false
    @Published var showFriendRequest : Bool = false
    @Binding var closeFlag : Bool
    @Binding var players : [User]
    var maxSelection : Int
    var includeSelf : Bool
    var onlyInUserGroup : Bool
    private var tickets: [AnyCancellable] = []
    var requestList : [String] = []
    var hasDetail : Bool = false
    var acceptNoReturn : Bool = false
    
    func addObservor(){
        NotificationCenter.default.publisher(for: .addFriend)
            .sink { [unowned self] (_) in
                 self.loadUser()
        }.store(in: &tickets)
    }
    
    
    init(closeFlag : Binding<Bool> , users : Binding<[User]>, maxSelection : Int ,includeSelf: Bool ,onlyInUserGroup : Bool,hasDetail : Bool ,acceptNoReturn:Bool){
        self.selectedUser = []
        self._closeFlag = closeFlag
        self._players = users
        let uid = Auth.auth().currentUser!.uid
        let abc = users.wrappedValue
        self.maxSelection = maxSelection
        self.includeSelf = includeSelf
        self.onlyInUserGroup = onlyInUserGroup
        self.hasDetail = hasDetail
        self.acceptNoReturn = acceptNoReturn
        self.loadUser()
        abc.map {
            if $0.id != uid {
                self.selectedUser.append($0)
            }
        }
        if let user = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser) {
            self.requestList = user.fdsRequest
        }
    }
    
    func addToSelectedList(user : User){
        print("add to row")
         if let index = selectedUser.firstIndex(of:user){
             selectedUser.remove(at: index)
         }else{
            if selectedUser.count < maxSelection {
                selectedUser.append(user)
            }
         }
     }
    
    func confirm(){
//        print("Confirm")
        if self.includeSelf {
//             print("include youself")
            if let yourself = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser){
                print(yourself.id)
//                print(selectedUser.contains(yourself))
                print(selectedUser.map{$0.id})
                if !selectedUser.contains(yourself){
                    print("add to list")
                    self.selectedUser.append(yourself)
                }
            }
        }
        self.players = self.selectedUser
        self.closeFlag.toggle()
    }
    
    func loadUser(){
        User.getFriends().then { [unowned self] (users)  in
            print(users.map{$0.id})
            var list : [User] = []
            if self.onlyInUserGroup {
                let groupUser = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser)
                list = users.filter({ (user) -> Bool in
                    groupUser?.contains(user) ?? true
                })
            }else{
                list = users
            }
            self.users = list
        }.catch({ (err) in
            Utility.showAlert(message: err.localizedDescription)
        })
    }
}
