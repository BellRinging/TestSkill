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
                                VStack{
                                    ImageView(withURL: player.imgUrl).standardImageStyle()
                                    Text("\(player.userName ?? "")").textStyle(size: 10).frame(width: 60)
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
                                VStack{
                                    ImageView(withURL: player.imgUrl).standardImageStyle()
                                    Text("\(player.userName ?? "")").textStyle(size: 10).frame(width: 60)
                                }
                                
                            }
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
                Button(action: {
                                        self.viewModel.search()
                                    }, label:{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.greenColor)
                                            .frame(maxWidth:.infinity )
                                            .frame(height: 40)
                                            .shadow(radius: 5)
                                            .overlay(
                                                Text("Search").foregroundColor(Color.white))
                                    })
                .padding()
                }
               
            }
     
            .navigationBarTitle("Search", displayMode: .inline)
        }.onAppear(){
            self.viewModel.initPeriod()
            self.viewModel.initFan()
        }
        .modal(isShowing: self.$viewModel.showSelectPlayerDetailLevel) {
            LazyView(DisplayFriendView(closeFlag: self.$viewModel.showSelectPlayerDetailLevel, users: self.$viewModel.playersDetailLevel, maxSelection: 1 ,includeSelf : false,acceptNoReturn: true ,showSelectAll: false))
        }.modal(isShowing: self.$viewModel.showSelectPlayerGameLevel) {
            LazyView(DisplayFriendView(closeFlag: self.$viewModel.showSelectPlayerGameLevel, users: self.$viewModel.playersGameLevel, maxSelection: 3 ,includeSelf : true,showSelectAll: false))
        }
        .modal(isShowing: self.$viewModel.showSearchGame) {
            LazyView(SearchGameView(closeFlag:self.$viewModel.showSearchGame,games:self.viewModel.games))
        }
        .modal(isShowing: self.$viewModel.showSearchGameDetail) {
            LazyView(SearchGameDetailView(closeFlag:self.$viewModel.showSearchGameDetail,gameRecords:self.viewModel.gameRecords))
           }
    }
    

}

