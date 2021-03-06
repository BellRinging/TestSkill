//
//  FriendRow.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 27/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct AddFriendRow: View {
    
    var user : User
    var isSelected : Bool
    var status : Int
    
    var body: some View {
        HStack(alignment: .center){
            UserDisplay(user:user)
            Text(user.email).textStyle(size: 12)
            
            if status == 0 {
                Image(systemName: "person.2")
                //fds
            }else if status == 1 {
                Image(systemName: "person.crop.circle.fill.badge.plus")
                //pending
            }else if status == 2 {
                Image(systemName: "person.crop.circle.fill.badge.exclam")
                //pending
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }.padding(.horizontal)
    }
}
