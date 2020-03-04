//
//  TestMain.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Combine

struct GameView: View {
        
    @ObservedObject var viewModel: GameViewModel

    
    init(){
        print("Init GameView")
        viewModel = GameViewModel.shared
     
    }
    
    var body: some View {
    
        GeometryReader { geometry in
            NavigationView{
                VStack{
                    if (self.viewModel.status == .loading) {
                        Text("loading...")
                    }else{
                        GameViewUpperArea()
                        GameViewListHistoryArea(groupUsers: self.viewModel.groupUsers, sectionHeader: self.viewModel.sectionHeader, games: self.viewModel.games, status: self.viewModel.status)
                        Spacer()
                    }
                }
                .navigationBarItems(leading: self.dropDown.padding(.leading , (geometry.size.width-200-20) / 2.0), trailing: self.rightImg)
                .navigationBarTitle("", displayMode: .inline)
            }
            .modal(isShowing: self.$viewModel.showGroupDisplay, content: {
                DisplayPlayerGroupView(closeFlag: self.$viewModel.showGroupDisplay, returnGroup: self.$viewModel.group)
            })
            .modal(isShowing: self.$viewModel.showAddGameDisplay, content: {
                AddGameView()
            })
            .onAppear(){
                if (self.viewModel.status == .loading){
                    print(".loading")
                    self.viewModel.loadUserGroup()
                }
            }
        }
    }

    var dropDown : some View {
        VStack {
            Text(self.viewModel.group?.groupName ?? "")
                .foregroundColor(Color.white)
                .titleStyle()
        }
        .frame(width: 200)
        .background(Color.clear)
        .onTapGesture {
            withAnimation {
                self.viewModel.showGroupDisplay = true
            }
        }
    }
    
    var rightImg : some View {
        Button(action: {
            withAnimation {
                self.viewModel.showAddGameDisplay = true
            }
        }) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 20,height: 20)
        }
    }
}
