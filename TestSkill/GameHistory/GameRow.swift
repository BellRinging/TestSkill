//
//  TestGameRow.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct GameRow: View {
    
    @ObservedObject var viewModel: GameRowViewModel

    init(game:Game){
        viewModel = GameRowViewModel(game:game )
        viewModel.initial()
    }
    
    var body: some View {
        HStack{
            VStack{
                Image(viewModel.game.gameType == "Big2" ? "Big2Icon" : "mahjongIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width:54)
                Text(viewModel.date).textStyle(size: 12)
                Text(viewModel.location).textStyle(size: 10)
            }.layoutPriority(1)
            
            ForEach(0..<viewModel.otherPlayers.count  ,id: \.self) { (index) in
                VStack{
                    ImageView(withURL: self.viewModel.otherPlayers[index].imgUrl)
                        .standardImageStyle()
                        .overlay(
                            Circle()
                                .stroke( self.viewModel.otherPlayersResult[index] ? Color.greenColor:Color.clear, lineWidth: 1.5))
                    Text(self.viewModel.otherPlayers[index].userName)
                        .textStyle(size: 10).frame(width: 50)
                }
            }
            Spacer()
            if self.viewModel.currentPlayerExist {
                Text("\(viewModel.win ? viewModel.amount:viewModel.amount * -1)")
                    .foregroundColor(viewModel.win ? Color.greenColor:Color.redColor)
                    .textStyle(size: 22)
            }else{
//                Text("N/A").textStyle(size: 20 ,color: Color.redColor)
                EmptyView()
            }
        }
    }
}
