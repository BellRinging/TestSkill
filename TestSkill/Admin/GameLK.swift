//
//  GameLK.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 8/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct GameLK: View {
    
    @Binding var closeFlag : Bool
    @Binding var gameObj : Game?
    
     @ObservedObject var viewModel = GameLKModel()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(self.viewModel.games) { game in
                    GameRow(game: game).onTapGesture {
                        self.gameObj = game
                        self.closeFlag.toggle()
                    }
                }
            }
            .navigationBarTitle("Game", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$closeFlag),trailing: emptyReturn() )
        }
    }
    
    
    func emptyReturn() -> some View{
        Button(action: {
            self.gameObj = nil
            self.closeFlag.toggle()
        }) {
            Text("Empty Return")
        }
    }
}


