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
                
                HStack{
                    Text("Game:").textStyle(size: 12,color: Color.blue)
                    if self.viewModel.gameTemp != nil{
                        VStack{
                            Text("\(self.viewModel.gameTemp!.date) \(self.viewModel.gameTemp!.location)").textStyle(size: 12)
                        }
                    }else{
                        Text("No Selection").textStyle(size: 12)
                    }
                    Spacer()
                    if self.viewModel.gameTemp == nil{
                        Button("Select Game"){
                            self.viewModel.isShowGameLK = true
                        }.textStyle(size: 12)
                    }else{
                        Button("Clear Selection"){
                            self.viewModel.gameTemp = nil
                        }.textStyle(size: 12,color: Color.redColor)
                    }
                }.padding()
                
                
                
                HStack{
                    Button("UnFlown"){
                        Utility.showAlert(message: "Confirm?", callBack: self.viewModel.unFlownGame)
                    }
                    Button("Delete"){
//                        Utility.showAlert(message: "Confirm?", callBack: self.viewModel.DeleteGame)
                    }
                }
                Button("UpdateGameDetail"){
                    Utility.showAlert(message: "Confirm?", callBack: self.viewModel.updateGame)
                }
                Button("deleteGame"){
                    Utility.showAlert(message: "Confirm?", callBack: self.viewModel.deleteGame)
                }
                HStack{
                    Button("SetActUser"){
                        Utility.showAlert(message: "Confirm?", callBack: self.viewModel.setActUser)
                    }
                    Button("Remove ActUser"){
                        Utility.showAlert(message: "Confirm?", callBack: self.viewModel.removeActUser)
                    }
                }
                        
                
            }.padding()
            transferData().padding()
            Button("UpdateUserBalance"){
                              Utility.showAlert(message: "Confirm?", callBack: self.viewModel.updateUser)
                          }
        }.modal(isShowing: self.$viewModel.isShowGameLK) {
            GameLK(closeFlag: self.$viewModel.isShowGameLK,gameObj:self.$viewModel.gameTemp)
        }
        .modal(isShowing: self.$viewModel.isShowPlayer1) {
            DisplayFriendView(closeFlag:  self.$viewModel.isShowPlayer1, users: self.$viewModel.player1, maxSelection: 1, includeSelfInReturn: false)
        }
        .modal(isShowing: self.$viewModel.isShowPlayer2) {
            DisplayFriendView(closeFlag:  self.$viewModel.isShowPlayer2, users: self.$viewModel.player2, maxSelection: 1, includeSelfInReturn: false)
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
                Utility.showAlert(message: "Confirm?", callBack: self.viewModel.transfer)
            }
        }
    }

}
