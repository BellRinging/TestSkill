//
//  TestAddGroup.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct AddGameView: View {
    
    @ObservedObject var viewModel : AddGameViewModel
    
    init(){
        viewModel = AddGameViewModel()
    }
    
    var body: some View {
        
        NavigationView{
            ZStack{
                Color.whiteGaryColor.edgesIgnoringSafeArea(.vertical)
                VStack{
                VStack{
                    HStack(alignment: .bottom){
                        Text(self.viewModel.getTextFromDate(date: self.viewModel.calenderManager.selectedDate))
                        Spacer()
                        Image("calendar")
                            .resizable()
                            .scaledToFit().frame(width: 30)
                    }
                    .padding([.trailing,.leading,.top])
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.viewModel.showCalendar.toggle()
                    }.sheet(isPresented: self.$viewModel.showCalendar) {
                        RKViewController(isPresented: self.$viewModel.showCalendar, rkManager: self.viewModel.calenderManager)
                    }
                    
                    
                    TextField("Location", text: $viewModel.location)
                        .textFieldStyle(BottomLineTextFieldStyle())
                        .padding([.leading,.trailing,.top])
                    
                    Button(action: {
                        self.viewModel.showSelectPlayer.toggle()
                    }) {
                        AddGameViewRow(players: self.viewModel.players)
                    }.sheet(isPresented: self.$viewModel.showSelectPlayer) {
//                        AddGameDisplayUserView(parent : self.viewModel)
                        DisplayUserView(flag: self.$viewModel.showSelectPlayer, users: self.$viewModel.players ,maxSelection: 4)
                    }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(SwiftUI.Color.green)
                        .frame(width: UIScreen.main.bounds.width - 50, height: 40)
                        .overlay(
                            Button(action: {
                                self.viewModel.saveGame()
                            }, label:{
                                Text("確認").foregroundColor(Color.white)
                            })
                    )
                        .padding()
                        .shadow(radius: 5)
                }
                .background(Color.white)
                .padding([.trailing,.leading,.top], 10)
                .cornerRadius(10)
                .shadow(radius: 5)
                    Spacer()
                }
            }
            .navigationBarTitle("Add Game", displayMode: .inline)
        .navigationBarItems(leading: cancelButton())
            
        }
    }
    
    func cancelButton() -> some View {
        Button(action: {
//            self.showAddGameDisplay = false
            NotificationCenter.default.post(name: .dismissAddGameView, object: nil,userInfo: nil)
        }) {
            Image(systemName: "xmark.circle")
        }
    }
    
}

