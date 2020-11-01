//
//  ProfileViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 12/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import Promises
import SwiftUI

class ProfileViewModel: ObservableObject {
   
    @Binding var player : User
    @Published var firend : [User] = []
    var showEditButton = false
    @Published var showEditPage : Bool = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
    
    init(player : Binding<User>){
        self._player = player
        let uid = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!.id
        if player.wrappedValue.owner == uid {
            showEditButton = true
        }else{
            showEditButton = false
        }
        self.loadFriend()
    }
    
    func deleteAccount(){
        
        let task1 = Game.getGameByUserId(userId: player.id)
        let task2 = PlayGroup.getByUserId(id: player.id)
        Promises.all(task1, task2).then { (games,groups) in
            if games.count == 0 &&  groups.count == 0 {
                print("start delete")
                self.player.delete()
                self.mode.wrappedValue.dismiss()
                NotificationCenter.default.post(name: .deleteFriend , object: self.player)
            }else{
                Utility.showAlert(message: "Cant delete before user contain game/group record")
            }
        }
    }
    
    
    func loadFriend(){
        var list : [Promise<User?>] = []
        for fds in player.friends {
            list.append(User.getById(id: fds))
        }
        Promises.all(list).then{ users in
            let users2 = users.compactMap{$0}
            print("User total/find" , users.count , users2.count)
            self.firend.append(contentsOf: users2 )
            //clean up the friend list
            for i in (0..<users.count).reversed() {
                if  users[i] == nil {
                    print(self.player.friends[i])
                    self.player.removeFriend(userId: self.player.friends[i])
                    self.player.friends.remove(at: i)
                }
            }
            
            
//            player.removeFriend(userId: <#T##String#>)
            
            
        }.catch{ err in
            Utility.showAlert(message: err.localizedDescription)
        }
    }
}
