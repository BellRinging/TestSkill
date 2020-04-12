 import Foundation
 import FirebaseAuth
 import Combine
 import SwiftUI
 import Promises




 class FriendViewModel: ObservableObject {
    
    @Binding var closeFlag : Bool
    @Published var searchText : String = ""
    @Published var showCancelButton : Bool = false
    @Published var users : [User] = []
    @Published var usersStatus : [Int] = []
    @Published var selectedUsers : [User] = []
    var fdsList : [String] = []
    var pendingList : [String] = []
    var fdRequestList : [String] = []
 
    
    init(closeFlag : Binding<Bool>){
        self._closeFlag = closeFlag
        if let userObject = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser){
            self.fdsList = userObject.friends ?? []
            self.pendingList = userObject.fdsPending ?? []
            self.fdRequestList = userObject.fdsRequest ?? []
            print(self.pendingList )
        }
    }
        
    func SearchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var list : [Promise<[User]>] = []
        list.append(User.searchUserByEmail(text:searchText))
        list.append(User.searchUserByName(text:searchText))
        Promises.all(list).then { result in
            var list1 = result[0]
            list1.append(contentsOf: result[1])
            let uniList = Array(Set(list1)).filter{$0.id != uid}
            var statusList : [Int] = []
            for user in uniList {
                var status : Int = 3
                if self.fdsList.contains(user.id){
                    status = 0
                }
                if self.pendingList.contains(user.id){
                    status = 1
                }
                if self.fdRequestList.contains(user.id){
                    status = 2
                }
                statusList.append(status)
            }
            self.users = uniList
            self.usersStatus = statusList
        }
    }
    
    
    func addFriendPendding(){
        var user = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
        let uid = user.id

        
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        let createDate = formatter.string(from: Date())

        var promiseList = self.selectedUsers.map({$0.updateFdsRequest(userId: uid)})
        promiseList.append(contentsOf: self.selectedUsers.map({user.updateFdsPending(userId: $0.id)}))
     

        Promises.all(promiseList).then { _ in
            print("Completed")
            user.fdsPending.append(contentsOf: self.selectedUsers.map{$0.id})
            print(user.fdsPending)
            UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
            self.closeFlag.toggle()
            print("Send fds request")
            self.selectedUsers.map({
                let id = UUID().uuidString
                let fdsRequest = FdsRequest(id: id, fromUserId: uid, fromUserName: user.userName, toUserId: $0.id, fcmToken: $0.fcmToken, createDate: createDate)
                fdsRequest.save()
            })
        }
        NotificationCenter.default.post(name: .addFriend, object: 1)
    }
 }
