//
//  SearchView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI


struct SearchView: View {
    
     @ObservedObject var viewModel: SearchViewModel = SearchViewModel()
    
    init()
      {
          UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
      }

    
    var body: some View {
        NavigationView {
            VStack{
            Form {
                Section(header:RadioButton(text: "Game Detail", radioSelection: $viewModel.radioSelection)) {
                    Button(action: {
                        withAnimation {
                            self.viewModel.showSelectPlayerDetailLevel = true
                        }
                    }) {
                        HStack{
                            Text("Players").foregroundColor(Color.primary)
                            Spacer()
                            ForEach(viewModel.playersDetailLevel) { (player) in
                                UserDisplay(user:player)
                            }
                        }
                    }
                    
                    Button(action: {
                                    withAnimation {
                                        self.viewModel.showSelectGame = true
                                    }
                                }) {
                                    HStack{
                                        Text("Game").foregroundColor(Color.primary)
                                        Spacer()
                                        if self.viewModel.selectedGame != nil{
                                            VStack{
                                                Text("\(self.viewModel.selectedGame!.date) \(self.viewModel.selectedGame!.location)")
                                            }
                                        }
                                    }
                                }
                    
                    HStack{
                        Picker(selection: $viewModel.selectedWinLose,
                               label: Text("Win or Lose"),
                               content: {
                                ForEach(0 ..< self.viewModel.winLoses.count,id: \.self) {
                                    Text(self.viewModel.winLoses[$0]).tag($0)
                                }
                        })
                        
                    }
                    HStack{
                        Picker(selection: $viewModel.selectedPeriodDetailLevel,
                               label: Text("Periods"),
                               content: {
                                ForEach(0 ..< self.viewModel.periods.count,id: \.self) {
                                    Text("\(self.viewModel.periods[$0])").tag($0)
                                }
                        })
                    }
                    HStack{
                        Picker(selection: self.$viewModel.selectedWinType,
                               label: Text("Win Type"),
                               content: {
                                ForEach(0 ..< self.viewModel.winType.count,id: \.self) {
                                    Text("\(self.viewModel.winType[$0])").tag($0)
                                }
                        })
                        
                    }
                    
                    HStack{
                        Picker(selection: self.$viewModel.selectedFanDetailLevel,
                               label: Text("Fans"),
                               content: {
                                ForEach(0 ..< self.viewModel.fans.count,id: \.self) {
                                    Text("\(self.viewModel.fans[$0])").tag($0)
                                }
                        })
                        
                    }
                }
                Section(header:RadioButton(text: "Game", radioSelection: $viewModel.radioSelection).padding(.vertical,0)) {
                    Button(action: {
                        withAnimation {
                            
                            self.viewModel.showSelectPlayerGameLevel = true
                        }
                    }) {
                        HStack{
                            Text("Comination").foregroundColor(Color.primary)
                            Spacer()
                            ForEach(viewModel.playersGameLevel) { (player) in
                                UserDisplay(user: player)
                            }
                            Spacer()
                        }
                    }
                    Button(action: {
                        withAnimation {
                            
                            self.viewModel.showExcludePlayer = true
                        }
                    }) {
                        HStack{
                            Text("Exclude").foregroundColor(Color.primary)
                            Spacer()
                            ForEach(viewModel.playersExclude) { (player) in
                                UserDisplay(user: player)
                            }
                            Spacer()
                        }
                    }
                    HStack{
                        Picker(selection: self.$viewModel.selectedLocation,
                               label: Text("Location"),
                               content: {
                                ForEach(0 ..< self.viewModel.location.count,id: \.self) {
                                    Text("\(self.viewModel.location[$0])").tag($0)
                                }
                        })
                    }
                    HStack{
                        HStack {
                            RadioButton(text: "Any", radioSelection: $viewModel.radioWinLoses)
                            RadioButton(text: "Win", radioSelection: $viewModel.radioWinLoses)
                            RadioButton(text: "Lose", radioSelection: $viewModel.radioWinLoses)
                            Spacer()
                            TextField("0", text: self.$viewModel.amount)
                        }
                    }
                    HStack {
                        Picker(selection: $viewModel.selectedPeriodGameLevel,
                               label: Text("Period"),
                               content: {
                                ForEach(0 ..< self.viewModel.periods.count,id: \.self) {
                                    Text(self.viewModel.periods[$0]).tag($0)
                                }
                        })
                    }
                }
  
                
                }
                navigationArea
            }
     
            .navigationBarTitle("Search", displayMode: .inline)
            .navigationBarItems(trailing: ConfirmButton(){
                 self.viewModel.search()
            })
        }.onAppear(){
            self.viewModel.initPeriod()
            self.viewModel.initFan()
        }
       
    }
    
    
    var navigationArea : some View {
        VStack{
            
            EmptyView().fullScreenCover(isPresented: self.$viewModel.showSelectPlayerDetailLevel) {
                DisplayFriendView(option:DisplayFriendViewOption(closeFlag: self.$viewModel.showSelectPlayerDetailLevel, users: self.$viewModel.playersDetailLevel, maxSelection: 1 ,includeSelfInReturn: false, acceptNoReturn: true ,showSelectAll: false,includeSelfInSeletion : true))
            }
            EmptyView()
                .fullScreenCover(isPresented:self.$viewModel.showSelectPlayerGameLevel) {
                DisplayFriendView(option:DisplayFriendViewOption(closeFlag: self.$viewModel.showSelectPlayerGameLevel, users: self.$viewModel.playersGameLevel, maxSelection: 4 ,includeSelfInReturn: false, acceptNoReturn: true, showSelectAll: false,includeSelfInSeletion : true))
            }
            EmptyView()
                .fullScreenCover(isPresented: self.$viewModel.showExcludePlayer) {
                DisplayFriendView(option:DisplayFriendViewOption(closeFlag: self.$viewModel.showExcludePlayer, users: self.$viewModel.playersExclude, includeSelfInReturn: false, acceptNoReturn: true, showSelectAll: false,includeSelfInSeletion : true))
            }
            EmptyView()
                .fullScreenCover(isPresented: self.$viewModel.showSearchGame) {
                SearchGameView(closeFlag:self.$viewModel.showSearchGame,games:self.viewModel.games)
            }
            EmptyView()
                .fullScreenCover(isPresented: self.$viewModel.showSearchGameDetail) {
                SearchGameDetailView(closeFlag:self.$viewModel.showSearchGameDetail,gameDetails:self.viewModel.gameDetails,refUser: self.viewModel.refUser)
            }
            EmptyView()
                .fullScreenCover(isPresented: self.$viewModel.showSelectGame) {
                GameLK(closeFlag:self.$viewModel.showSelectGame,gameObj : self.$viewModel.selectedGame)
            }
        }
    }
 
    

}

