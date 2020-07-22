//
//  File.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 2/2/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Promises



struct AddPlayGroupPlayerRow : View {
    var players : [User]
    
    var body : some View {
                         
        HStack(alignment: .center){
            VStack{
                Text("\(players.count)人").frame(minWidth: 50 )
            }.padding()
            if (players.count > 2) {
                ForEach(0...2 ,id: \.self) { (index) in
                    UserDisplay(user: self.players[index])
                }
                Text("More").textStyle(size: 8,color: Color.redColor)
            }else{
                ForEach(players ,id: \.id) { (player) in
                    UserDisplay(user: player)
                }
            }
            Spacer()
            Image(systemName: "ellipsis")
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                .standardImageStyle()
        }
    }
}
