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

    init(sectionHeader: [String],sectionHeaderAmt: [String:Int],games:[String:[Game]],status: pageStatus,lastGameDetail:GameDetail?,lastBig2GameDetail:Big2GameDetail?,noMoreGame:Bool,callback : @escaping (String,Int) -> () ){
        viewModel = GameViewListAreaViewModel(sectionHeader: sectionHeader,sectionHeaderAmt:sectionHeaderAmt, games: games, status: status,lastGameDetail:lastGameDetail,noMoreGame:noMoreGame,callback: callback)
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
    
    func gameDisplay(game:Game,period:String,index: Int) -> some View{
        
        GameRow(game: game)
            .frame(height: 60)
            .contextMenu{
                self.popUpMenu(game:game)
        }
        .onAppear {
            self.viewModel.itemAppears(period: period , index: index)
        }
    }

    var body: some View {
        VStack{
            if self.viewModel.status == .loading && self.viewModel.games.count == 0 {
                Text(self.viewModel.status == .loading ? "Loading":"No data")
            }else{
                List {
                    ForEach(self.viewModel.sectionHeader, id: \.self) { period in
                        Section(header: self.sectionArea(period:period)) {
                            ForEach(self.viewModel.games[period]!.indices ,id: \.id) { index in
                                NavigationLink(destination: self.navDest(game: self.viewModel.games[period]![index])){
                                    self.gameDisplay(game: self.viewModel.games[period]![index],period:period,index: index)
                                }
                            }.onDelete { (index) in
                                self.viewModel.selectedIndex = index.first!
                                self.viewModel.selectedPeriod = period
                                self.viewModel.showingDeleteAlert = true
                            }
                        }
                    }
                }
            }
        }.alert(isPresented: self.$viewModel.showingDeleteAlert) {
            Alert(title: Text("Confirm delete"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                self.viewModel.callback(self.viewModel.selectedPeriod , self.viewModel.selectedIndex)
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
    
    func sectionArea(period : String) -> some View {
        HStack{
            Text(period).font(MainFont.bold.size(12))
            Spacer()
            Text("\(self.viewModel.sectionHeaderAmt[period]!)")
                .titleFont(size: 12,color: self.viewModel.sectionHeaderAmt[period]! > 0 ? Color.greenColor: Color.redColor)
        }
    }

}

