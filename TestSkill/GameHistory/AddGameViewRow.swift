//
//  File.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 2/2/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Promises



struct AddGameViewRow : View {
    var players : [User]
    var viewModel : AddGameViewRowModel = AddGameViewRowModel()
    
    var body : some View {
        VStack{
            if players.count == 0 {
                Text("Tap to add player")
            }else{             
                HStack{
                       Spacer()
                    ForEach(players ,id: \.id) { (player) in
                        ImageView(withURL: player.imgUrl).standardImageStyle()
                    }
                    Spacer()
                }.padding()
             
            }
        }
    }
}
