//
//  ShowUser.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 12/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct DisplayFriendRow: View {
    var user : User
    var isSelected : Bool
    
//    init(user:User , isSelected : Bool = false){
//        self.user = user
//        self.isSelected = false
//    }
    
    var body: some View {
        HStack{
            ImageView(withURL: user.imgUrl)
                .standardImageStyle()
            Text(user.userName)
            Spacer()
            if self.isSelected {
                Image(systemName: "checkmark")
            }
        }.padding()
    }
}

