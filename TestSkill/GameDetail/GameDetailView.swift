//
//  TestSwiftUI.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 29/12/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct GameDetailView: View {
    
    @ObservedObject private var viewModel: GameDetailViewModel
    
    init(game: Game ,users:[User]){
        print("initial detail \(game.id)")
        viewModel = GameDetailViewModel(game: game ,users:users)
        viewModel.onInitial()
    }

    var body: some View {
        VStack{
            if self.viewModel.status == .loading {
                Text("Loading")
            }else{
                HStack {
                    VStack {
                        IndividualScoreDisplay(player: self.viewModel.displayBoard[0])
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.viewModel.eat(0)
                        }
                    }
                    VStack {
                        IndividualScoreDisplay(player: self.viewModel.displayBoard[1]).padding()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.viewModel.eat(1)
                        }
                        Text("流局").padding()
                        IndividualScoreDisplay(player: self.viewModel.displayBoard[2])
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.viewModel.eat(2)
                        }
                    }
                    VStack {
                        IndividualScoreDisplay(player: self.viewModel.displayBoard[3])
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.viewModel.eat(3)
                        }
                    }
                }
                .navigationBarTitle("\(viewModel.game.date) \(viewModel.game.location)" )
//                .navigationBarItems(leading: Text("Back"))
            }
        }
    }
}

