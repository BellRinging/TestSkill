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
    
    
    
    var gameArea : some View {
        VStack{
            HStack{
                Text("Game Level").titleFont(size: 16)
                Spacer()
            }.padding(.bottom,5)
            HStack{
                Spacer()
                if self.viewModel.gameTemp != nil{
                    VStack{
                        Button {
                            self.viewModel.gameTemp = nil
                        } label: {
                            Text("\(self.viewModel.gameTemp!.date) \(self.viewModel.gameTemp!.location)").textStyle(size: 12)
                        }
                    }
                }else{
                    Button {
                        self.viewModel.isShowGameLK = true
                    } label: {
                        Text("Select Game").textStyle(size: 12,color: Color.grayColor)
                    }
                }
                Spacer()
            }.padding(.bottom,5)
            if self.viewModel.gameTemp != nil{
                HStack{
                    Spacer()
                    Button {
                        Utility.showAlert(message: "Confirm?", callBack: self.viewModel.unFlownGame)
                    } label: {
                        Text("UnFlown").textStyle(size: 12,color: Color.greenColor)
                    }
                    Spacer()
                    Button {
                    } label: {
                        Text("Delete").textStyle(size: 12,color: Color.redColor)
                    }
                    Spacer()
                }
            }
            Divider()
        }
    }
    var body: some View {
        NavigationView{
            VStack{
                gameArea
                transferData()
                navigationArea
                Spacer()
            }.padding()
            .navigationBarTitle("Admin Page", displayMode: .inline)
        }
        
    }

                    
//
//                    Button("UpdateGameDetail"){
//                        Utility.showAlert(message: "Confirm?", callBack: self.viewModel.updateGame)
//                    }
//
//                    HStack{
//                        Button("SetActUser"){
//                            Utility.showAlert(message: "Confirm?", callBack: self.viewModel.setActUser)
//                        }
//                        Button("Remove ActUser"){
//                            Utility.showAlert(message: "Confirm?", callBack: self.viewModel.removeActUser)
//                        }
//                    }
//                    navigationArea
                    
                
//                Button("UpdateUserBalance"){
//                    Utility.showAlert(message: "Confirm?", callBack: self.viewModel.updateUser)
//                }
//                Spacer()
//    }
    
    var navigationArea : some View{
        VStack{
            EmptyView()
                .fullScreenCover(isPresented: self.$viewModel.isShowGameLK) {
                GameLK(closeFlag: self.$viewModel.isShowGameLK,gameObj:self.$viewModel.gameTemp)
            }
            EmptyView()
                .fullScreenCover(isPresented: self.$viewModel.isShowPlayer1) {
                DisplayFriendView(option: DisplayFriendViewOption(closeFlag:  self.$viewModel.isShowPlayer1, users: self.$viewModel.player1, maxSelection: 1, includeSelfInReturn: false))
            }
            EmptyView()
                .fullScreenCover(isPresented: self.$viewModel.isShowPlayer2) {
                DisplayFriendView(option: DisplayFriendViewOption(closeFlag:  self.$viewModel.isShowPlayer2, users: self.$viewModel.player2, maxSelection: 1, includeSelfInReturn: false))
            }
        }
    }
    
    func transferData() -> some View{
        VStack{
            HStack{
                Text("User").titleFont(size: 16)
                Spacer()
            }
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
                    
                            
                            VStack{
                                Circle()
                                    .fill(Color.greenColor)
                                    .standardImageStyle()
                                    .overlay(
                                        Image(systemName: "pencil")
                                            .resizable()
                                            .aspectRatio(contentMode: ContentMode.fit)
                                            .frame(width: 20 , height: 20)
                                ).shadow(radius: 5)
                                Text("Player1")
                                    .textStyle(size: 10).frame(width: 50)
                            }
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
                            VStack{
                                Image(systemName: "pencil")
                                    .standardImageStyle()
                                Text("Player2")
                                    .textStyle(size: 10).frame(width: 50)
                            }
                        }
                    }
                }
                Spacer()
            }
            if self.viewModel.player1.count > 0 {
                HStack{
                    Button("SetActUser"){
                        Utility.showAlert(message: "Confirm?", callBack: self.viewModel.setActUser)
                    }
                    Button("UpDateID"){
                        Utility.showAlert(message: "Confirm?", callBack: self.viewModel.transfer)
                    }
                }
            }
        }
    }

}
