//
//  GameViewListHistoryArea.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 18/2/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Combine

enum pageStatus {
    case loading
    case completed
}

struct GameViewListHistoryArea: View {
    
    var groupUsers : [User]
    var sectionHeader : [String]
    var games : [String:[Game]]
    var status : pageStatus
    
    var body: some View {
        VStack{
            if status == .loading{
                Text("loading")
            }else{
                List {
                    ForEach(self.sectionHeader, id: \.self) { period in
                        Section(header: self.sectionArea(text:period)) {
                            ForEach(self.games[period]! ,id: \.id) { game in
                                NavigationLink(destination:
                                LazyView(GameDetailView(game: game ,users :self.groupUsers))){
                                    GameRow(game: game, users: self.groupUsers)
                                        .frame(height: 50)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func sectionArea(text : String) -> some View {
           HStack{
               Spacer()
               Text(text).font(MainFont.bold.size(12))
           }
       }

}

