//
//  AdminView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 19/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct AdminView: View {
    
 @ObservedObject var viewModel = AdminViewModel()
    


    
    var body: some View {
        VStack{
            VStack{
                if self.viewModel.gameTemp == nil{
                    Button("Select Game"){
                        self.viewModel.isShowGameLK = true
                    }.padding()
                }else{
                    GameRow(game: self.viewModel.gameTemp!)
                }
                HStack{
                    Button("UnFlown"){
                        Utility.showAlert(message: "Confirm?", callBack: self.viewModel.unFlownGame)
                    }
                    Button("Delete"){
                        Utility.showAlert(message: "Confirm?", callBack: self.viewModel.DeleteGame)
                    }
                }        
            }.padding()
            transferData().padding()
        }.modal(isShowing: self.$viewModel.isShowGameLK) {
            GameLK(closeFlag: self.$viewModel.isShowGameLK,gameObj:self.$viewModel.gameTemp)
        }
        .modal(isShowing: self.$viewModel.isShowPlayer1) {
            DisplayFriendView(closeFlag:  self.$viewModel.isShowPlayer1, users: self.$viewModel.player1, maxSelection: 1, includeSelf: false)
        }
        .modal(isShowing: self.$viewModel.isShowPlayer2) {
            DisplayFriendView(closeFlag:  self.$viewModel.isShowPlayer2, users: self.$viewModel.player2, maxSelection: 1, includeSelf: false)
        }
    }
    
    func transferData() -> some View{
        VStack{
            HStack{
                Button(action: {
                    self.viewModel.isShowPlayer1 = true
                }) {
                    VStack{
                        if self.viewModel.player1.count > 0 {
                            VStack{
                                ImageView(withURL: self.viewModel.player1[0].imgUrl).standardImageStyle()
                                Text("\(self.viewModel.player1[0].userName)").textStyle(size: 10).frame(width: 50)
                            }
                        }else{
                            Text("Player1")
                        }
                    }
                }
                Button(action: {
                    self.viewModel.isShowPlayer2 = true
                }) {
                    VStack{
                        if self.viewModel.player2.count > 0 {
                            VStack{
                                ImageView(withURL: self.viewModel.player2[0].imgUrl).standardImageStyle()
                                Text("\(self.viewModel.player2[0].userName)").textStyle(size: 10).frame(width: 50)
                            }
                        }else{
                            Text("Player2")
                        }
                    }
                }
            }
            Button("UpDateID"){
                Utility.showAlert(message: "Confirm?", callBack: self.viewModel.UpdateId)
            }
        }
    }

}
