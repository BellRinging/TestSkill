//
//  ProfileViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 12/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import Promises

class ProfileViewModel: ObservableObject {
   
//   @Binding var closeFlag : Bool
    
    @Published var player : User
    @Published var firend : [User] = []
  
    
    init(player : User){
        self.player = player
        self.loadFriend()
    }
    
    
    func loadFriend(){
        var list : [Promise<User?>] = []
        for fds in player.friends {
            list.append(User.getById(id: fds))
        }
        Promises.all(list).then{ users in
            self.firend.append(contentsOf: users.compactMap{$0})
        }
        
    }
}
