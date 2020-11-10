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



struct GameViewListHistoryArea: View {
    
    @ObservedObject var viewModel: GameViewListAreaViewModel

    init(games: Binding<GameList>){
        viewModel = GameViewListAreaViewModel(games: games)
    }
    
    func popUpMenu(game: Game) -> some View{
        VStack {
            Button(action: {
                NotificationCenter.default.post(name: .flownGame, object: game)
            }){
                HStack {
                    Text("Flown")
                    Image(systemName: "lock")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth : 20)
                }
            }
            Button(action: {
                self.viewModel.selectedGame = game
                self.viewModel.showingDeleteAlert = true
            }){
                HStack {
                    Text("Remove")
                    Image(systemName: "trash")
                    .scaledToFit()
                    .frame(maxWidth : 20)
                }
            }
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
//                .listStyle(PlainListStyle())
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
                EmptyView()
//                LazyView(Big2DetailView(game: game,lastGameDetail : self.viewModel.lastBig2GameDetail))
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

}

