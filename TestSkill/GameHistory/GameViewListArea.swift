//
//  GameViewListHistoryArea.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 18/2/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Combine
import SwiftUIRefresh

struct GameViewListArea: View {
    
    @ObservedObject var viewModel: GameViewListAreaViewModel

    init(games: Binding<GameList>){
        viewModel = GameViewListAreaViewModel(games: games)
    }
    
    var body: some View {
        VStack{
            List {
                ForEach(0...self.viewModel.games.list.count - 1 ,id:\.self) { index in
                    Section(header: self.sectionArea(gamePassingObject: self.viewModel.games.list[index])) {
                        ForEach(0...self.viewModel.games.list[index].games.count - 1 ,id:\.self ) { index2 in
                            ZStack{
                                self.gameDisplay(game: self.viewModel.games.list[index].games[index2])
                                NavigationLink(destination: self.navDest(game: self.$viewModel.games.list[index].games[index2])){
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
            }
        }.alert(isPresented: self.$viewModel.showingDeleteAlert) {
            Alert(title: Text("Confirm delete"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                NotificationCenter.default.post(name: .deleteGame, object:  self.viewModel.selectedGame!)
                }, secondaryButton: .cancel()
            )
        }
    }
    
    func navDest(game:Binding<Game>) -> some View{
        return VStack{
            if game.wrappedValue.gameType == "Big2" {
                LazyView(Big2DetailView(game: game))
            }else{
                LazyView(GameDetailView(game: game ))
            }
        }
    }
    
    func sectionArea(gamePassingObject : GamePassingObject) -> some View {
        HStack{
            Text(gamePassingObject.id).font(MainFont.bold.size(12))
            Spacer()
            Text("\(gamePassingObject.periodAmt)")
                .titleFont(size: 12,color: gamePassingObject.periodAmt > 0 ? Color.greenColor: Color.redColor)
        }
    }
    
    func gameDisplay(game:Game) -> some View{
        GameRow(game: game)
            .frame(height: 60)
            .contextMenu{
                self.popUpMenu(game:game)
        }
        .onAppear {
            self.viewModel.itemAppears(game: game)
        }
    }
    
    func popUpMenu(game: Game) -> some View{
        VStack {
            Button(action: {
                NotificationCenter.default.post(name: .flownGame, object: game)
            }){
                Label("Flown", systemImage: "lock")
            }
            Button(action: {
                self.viewModel.selectedGame = game
                self.viewModel.showingDeleteAlert = true
            }){
                Label("Remove", systemImage: "trash")
            }
        }
    }

}

