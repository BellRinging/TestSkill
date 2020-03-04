//
//  ShowUser.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 12/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct DisplayUserRow: View {
    var user : User
    var isSelected : Bool
    
    var body: some View {
        HStack{
            ImageView(withURL: user.imgUrl)
                .standardImageStyle()
            Text(user.userName!)
            Spacer()
            if self.isSelected {
                Image(systemName: "checkmark")
            }
        }.padding()
    }
}

