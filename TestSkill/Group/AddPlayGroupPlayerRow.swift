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
                    VStack{
                        ImageView(withURL: self.players[index].imgUrl).standardImageStyle()
                        Text("\(self.players[index].userName ?? "")").textStyle(size: 10).frame(width: 60)
                    }
                }
                Text("More").textStyle(size: 8,color: Color.redColor)
            }else{
                ForEach(players ,id: \.id) { (player) in
                    VStack{
                        ImageView(withURL: player.imgUrl).standardImageStyle()
                        Text("\(player.userName ?? "")").textStyle(size: 10).frame(width: 60)
                    }
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
