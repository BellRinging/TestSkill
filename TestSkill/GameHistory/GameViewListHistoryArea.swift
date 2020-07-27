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

enum pageStatus {
    case loading
    case completed
}

struct GameViewListHistoryArea: View {
    
    @ObservedObject var viewModel: GameViewListAreaViewModel

    init(games: GameList,status: pageStatus,lastGameDetail:GameDetail?,lastBig2GameDetail:Big2GameDetail?,noMoreGame:Bool){
        viewModel = GameViewListAreaViewModel(games: games, status: status,lastGameDetail:lastGameDetail,noMoreGame:noMoreGame)
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
                NotificationCenter.default.post(name: .deleteGame, object: game)
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
            if self.viewModel.status == .loading && self.viewModel.games.list.count == 0 {
                Text(self.viewModel.status == .loading ? "Loading":"No data")
            }else{
                List {
                    ForEach(self.viewModel.games.list) { gamePassingObject in
                        Section(header: self.sectionArea(gamePassingObject:gamePassingObject)) {
                            ForEach(gamePassingObject.games) { game in
                                NavigationLink(destination: self.navDest(game: game)){
                                    self.gameDisplay(game: game)
                                }
                            }.onDelete { (index) in
                                self.viewModel.selectedGame = gamePassingObject.games[index.first!]
                                self.viewModel.showingDeleteAlert = true
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
    
    func navDest(game:Game) -> some View{
        VStack{
            if game.gameType == "Big2" {
                LazyView(Big2DetailView(game: game,lastGameDetail : self.viewModel.lastBig2GameDetail))
            }else{
                LazyView(GameDetailView(game: game ,lastGameDetail : self.viewModel.lastGameDetail))
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

