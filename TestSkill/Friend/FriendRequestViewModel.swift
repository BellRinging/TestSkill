 import Foundation
 import SwiftUI
 import Promises

 class FriendRequestViewModel: ObservableObject {
    
    @Binding var closeFlag : Bool
    @Published var users : [User] = []
    @Published var selectedUsers : [User] = []
    
    init(closeFlag : Binding<Bool>){
        self._closeFlag = closeFlag
        self.users = []
          self.getUser()
    }
    
    func getUser(){
        if let userObject = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser){
            let pendingList = userObject.fdsRequest ?? []
            var list : [Promise<User?>] = []
            list.append(contentsOf: pendingList.map { User.getById(id: $0)})
            Promises.all(list).then { users in
                self.users = users.compactMap { $0}
            }
        }  
    }
    
    func addToSelectedList(user : User){
        if let index = selectedUsers.firstIndex(of:user){
            selectedUsers.remove(at: index)
        }else{
            selectedUsers.append(user)
        }
    }
    
    func addFriend(){
        var user = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
        let uid = user.id
        var promiseList = self.selectedUsers.map({$0.updateFriend(userId: uid)})
        promiseList.append(contentsOf: self.selectedUsers.map({user.updateFriend(userId: $0.id)}))
        promiseList.append(contentsOf: self.selectedUsers.map({$0.removeFdsPending(userId: uid)}))
        promiseList.append(contentsOf: self.selectedUsers.map({user.removeFdsRequest(userId: $0.id)}))
        
        Promises.all(promiseList).then { _ in
            print("Completed")
            
            self.selectedUsers.map{
                if let index = user.fdsRequest.firstIndex(of: $0.id){
                    user.fdsRequest.remove(at: index)
                }
            }
            UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
            self.closeFlag.toggle()
        }
        NotificationCenter.default.post(name: .addFriend, object: 1)
    }
 }
