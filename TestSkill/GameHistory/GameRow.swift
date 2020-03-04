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

    init(game:Game,users:[User]){
        viewModel = GameRowViewModel(game:game ,users:users)
        viewModel.initial()
    }
    
    var body: some View {
        HStack{
            VStack{
                Text(viewModel.date).font(MainFont.bold.size(12))
                Text(viewModel.location).font(MainFont.light.size(10))
            }
            
            ForEach(0..<viewModel.otherPlayers.count  ,id: \.self) { (index) in
                ImageView(withURL: self.viewModel.otherPlayers[index].imgUrl).standardImageStyle()
                    .overlay(Circle().stroke( self.viewModel.otherPlayersResult[index] ? Color.red:Color.clear, lineWidth: 2))
            }
            Spacer()
            Text("\(viewModel.amount)")
                .foregroundColor(viewModel.win ? Color.greenColor:Color.redColor)
            .bigTitleStyle()
        }
    }
}
