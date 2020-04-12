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

    init(groupUsers:[User],sectionHeader: [String],sectionHeaderAmt: [String:Int],games:[String:[Game]],status: pageStatus,lastGameDetail:GameDetail?,callback : @escaping (String,Int) -> () ){
        viewModel = GameViewListAreaViewModel(groupUsers: groupUsers, sectionHeader: sectionHeader,sectionHeaderAmt:sectionHeaderAmt, games: games, status: status,lastGameDetail:lastGameDetail, callback: callback)
    }

    var body: some View {
        VStack{
            if self.viewModel.status == .loading && self.viewModel.games.count == 0 {
                Text(self.viewModel.status == .loading ? "Loading":"No data")
            }else{
                List {
                    ForEach(self.viewModel.sectionHeader, id: \.self) { period in
                        Section(header: self.sectionArea(period:period)) {
                            ForEach(self.viewModel.games[period]! ,id: \.id) { game in
                                NavigationLink(destination:
                                LazyView(GameDetailView(game: game ,users :self.viewModel.groupUsers ,lastGameDetail : self.viewModel.lastGameDetail))){
                                    GameRow(game: game)
                                        .frame(height: 60)
                                        .contextMenu{
                                        VStack {
                                            Button(action: {
                                                   NotificationCenter.default.post(name: .flownGame, object: game)
                                            }){
                                                HStack {
                                                    Text("Flown")
                                                    Image(systemName: "lock")
                                                        .resizable()
                                                        .frame(maxWidth : 20)
                                                }
                                            }
                                            Button(action: {
                                                   NotificationCenter.default.post(name: .deleteGame, object: game)
                                            }){
                                                HStack {
                                                    Text("Remove")
                                                    Image(systemName: "trash")
                                                }
                                            }
                                        }
                                    }
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
    
    func sectionArea(period : String) -> some View {
           HStack{
            Text(period).font(MainFont.bold.size(12))
            Spacer()
            Text("\(self.viewModel.sectionHeaderAmt[period]!)").titleFont(size: 12,color: self.viewModel.sectionHeaderAmt[period]! > 0 ? Color.greenColor: Color.red)
           }
       }

}

