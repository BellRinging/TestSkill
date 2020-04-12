//
//  TestGameRow.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct GameRow: View {
    
    @ObservedObject var viewModel: GameRowViewModel

    init(game:Game){
        viewModel = GameRowViewModel(game:game )
        viewModel.initial()
    }
    
    var body: some View {
        HStack{
            VStack{
                Text(viewModel.date).font(MainFont.bold.size(12))
                Text(viewModel.location).font(MainFont.light.size(10))
            }
            
            ForEach(0..<viewModel.otherPlayers.count  ,id: \.self) { (index) in
                VStack{
                    ImageView(withURL: self.viewModel.otherPlayers[index].imgUrl).standardImageStyle()
                        .overlay(Circle().stroke( self.viewModel.otherPlayersResult[index] ? Color.greenColor:Color.clear, lineWidth: 1.5))
                    Text("\(self.viewModel.otherPlayers[index].userName ?? "")").textStyle(size: 10).frame(width: 50)
                }
                
            }
            Spacer()
            Text("\(viewModel.amount)")
                .foregroundColor(viewModel.win ? Color.greenColor:Color.redColor)
            .bigTitleStyle()
        }
    }
}
