//
//  GameViewListHistoryArea.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 18/2/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Foundation
import Combine
import FirebaseAuth
import Promises


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
                                    SearchGameRow(game: game)
//                                        .frame(height: 50)
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

struct SearchGameRow: View {
    
    @ObservedObject var viewModel: SearchGameRowViewModel

    init(game:Game){
        viewModel = SearchGameRowViewModel(game:game )
        viewModel.initial()
    }
    
    var body: some View {
        HStack{
            VStack{
                Image(viewModel.game.gameType == "Big2" ? "Big2Icon" : "mahjongIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width:50)
                Text(viewModel.date).textStyle(size: 12)
                Text(viewModel.location).textStyle(size: 10)
            }
            Spacer()
            ForEach(0..<viewModel.players.count  ,id: \.self) { (index) in
                VStack{
                    ImageView(withURL: self.viewModel.players[index].imgUrl)
                        .standardImageStyle()
//                        .overlay(
//                            Circle()
//                                .stroke( self.viewModel.playersResult[index] ? Color.greenColor:Color.clear, lineWidth: 1.5))
                    Text(self.viewModel.players[index].userName)
                        .textStyle(size: 10).frame(width: 50)
                    Text("\(self.viewModel.playersAmount[index])")
                        .textStyle(size: 18,color: self.viewModel.playersResult[index] ? Color.greenColor:Color.redColor)
                }
            }
            Spacer()
                .foregroundColor(viewModel.win ? Color.greenColor:Color.redColor)
                .textStyle(size: 24)
        }
    }
}




class SearchGameRowViewModel: ObservableObject {
    
    var date : String = ""
    var location : String = ""
    var win : Bool = false
    var amount : Int = 0
    @Published var players : [User] = []
    @Published var playersResult : [Bool] = []
    @Published var playersAmount : [Int] = []
    
    init(game:Game ) {
        self.game = game
    }
    
    var users:[User] = []
    var game : Game
    
    func initial(){
        location = game.location
        let tempDate = game.date
        date = "\(tempDate.suffix(2))/\(tempDate.prefix(6).suffix(2))/\(tempDate.prefix(4))"
        if let groupUser = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser){
            let _ = game.result.map { (key,value) in
                playersAmount.append(value)
                playersResult.append(value > 0 ? true : false)
                let user = groupUser.filter{$0.id == key}.first!
                self.players.append(user)
            }
        }
    }
}
