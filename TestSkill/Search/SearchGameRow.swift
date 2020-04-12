//
//  GameViewListHistoryArea.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 18/2/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI



struct SearchGameViewListHistoryArea: View {
    
    var sectionHeader : [String]
    var games : [String:[Game]]

    var body: some View {
        VStack{
            if games.count == 0 {
                Text("No data")
            }else{
                List {
                    ForEach(self.sectionHeader, id: \.self) { period in
                        Section(header: self.sectionArea(text:period)) {
                            ForEach(self.games[period]! ,id: \.id) { game in
                                    GameRow(game: game)
                                        .frame(height: 50)
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

