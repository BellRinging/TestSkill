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
        }
    }
    
    
    func main() -> some View{
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
                
                Picker("", selection: self.$viewModel.selectedType) {
                                   Text("Mahjong").tag(0)
                                   Text("Big2").tag(1)
                               }
                               .pickerStyle(SegmentedPickerStyle()).padding(.horizontal)
                
                TextField("Location", text: $viewModel.location)
                    .textFieldStyle(BottomLineTextFieldStyle())
                    .padding([.leading,.trailing,.top])
                
            
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
    }
    
    func playerArea() -> some View {
        Button(action: {
            self.viewModel.showSelectPlayer.toggle()
        }) {
            AddGameViewRow(players: self.viewModel.players)
        }.sheet(isPresented: self.$viewModel.showSelectPlayer) {
            DisplayFriendView(closeFlag: self.$viewModel.showSelectPlayer, users: self.$viewModel.players ,maxSelection: 3 ,includeSelf: true,onlyInUserGroup: true)
        }
    }
    
}

