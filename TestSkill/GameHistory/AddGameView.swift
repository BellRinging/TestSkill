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
    
    init(closeFlag : Binding<Bool>){
        viewModel = AddGameViewModel(closeFlag: closeFlag)
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.whiteGaryColor.edgesIgnoringSafeArea(.vertical)
                main()
            }
            .navigationBarTitle("Add Game", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag))
        }.modal(isShowing: self.$viewModel.showLocationView) {
            LocationView(closeFlag: self.$viewModel.showLocationView, location: self.$viewModel.location,singleSelect: true)
        }
    }
    
    
    func main() -> some View{
        VStack{
            VStack(alignment: .center){
                HStack(alignment: .bottom){
                    TextField("", text: self.$viewModel.displayDate).frame(width: 200).padding()
                    Spacer()
                    Image("calendar")
                        .resizable()
                        .scaledToFit().frame(width: 30)
                        .onTapGesture {
                            self.viewModel.showCalendar.toggle()
                    }
                    .sheet(isPresented: self.$viewModel.showCalendar,onDismiss: self.viewModel.setDate) {
                        RKViewController(isPresented: self.$viewModel.showCalendar, rkManager: self.viewModel.calenderManager)
                    }
                }
                .padding([.trailing,.leading,.top])
                
                
                Picker("", selection: self.$viewModel.selectedType) {
                    Text(GameType.mahjong.rawValue).tag(0)
                    Text(GameType.big2.rawValue).tag(1)
                               }
                               .pickerStyle(SegmentedPickerStyle()).padding(.horizontal)
                Button(action: {
                    self.viewModel.showLocationView = true
                }) {
                    VStack{
                    HStack{
                        Text("Location").textStyle(size: 14)
                        Spacer()
                        Text(self.viewModel.location=="" ? "<Tap to add location>" :self.viewModel.location).textStyle(size: 14)
                    }.padding()
                    Divider()
                    }
                }
            
                playerArea().frame(height : 60)
                
                Button(action: {
                    self.viewModel.saveGame()
                }, label:{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(SwiftUI.Color.green)
                        .frame(width: UIScreen.main.bounds.width - 50, height: 40)
                        .overlay(
                            Text("確認").foregroundColor(Color.white)
                    )
                }).padding()
                    .shadow(radius: 5)
                
                
            }
            .background(Color.white)
            .padding([.trailing,.leading,.top], 10)
            .cornerRadius(10)
            .shadow(radius: 5)
            Spacer()
        }
//
    }
    
    func playerArea() -> some View {
        Button(action: {
            self.viewModel.showSelectPlayer.toggle()
        }) {
            AddGameViewRow(players: self.viewModel.players)
        }.sheet(isPresented: self.$viewModel.showSelectPlayer) {
            DisplayFriendView(closeFlag: self.$viewModel.showSelectPlayer, users: self.$viewModel.players ,maxSelection: 4 ,includeSelfInReturn: false,onlyInUserGroup: true,includeSelfInSeletion: true)
        }
    }
    
}

