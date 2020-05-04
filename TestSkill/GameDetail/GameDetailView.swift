//
//  TestSwiftUI.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 29/12/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct GameDetailView: View {
    
    @ObservedObject private var viewModel: GameDetailViewModel
    
    init(game: Game ,lastGameDetail : GameDetail?){
        viewModel = GameDetailViewModel(game: game, lastGameDetail: lastGameDetail)
        viewModel.onInitial()
    }
    
    func lastRecordView() -> some View{
        VStack{
            if self.viewModel.lastGameDetail != nil {
                VStack{
                    HStack{
                        Spacer()
                        ForEach(self.viewModel.lastGameWin) { (win) in
                            VStack{
                                ImageView(withURL: win.imgUrl).standardImageStyle()
                                Text("\(win.userName ?? "")").textStyle(size: 10).frame(width: 50)
                            }
                        }
                        VStack{
                            Text(self.viewModel.lastGameDetail == nil ? "" :"Last Record:")
                                .foregroundColor(Color.redColor)
                                .textStyle(size: 10)
                            HStack{
                                Text(self.viewModel.lastGameType == "Self" ? "自摸":"打出").textStyle(size: 10).padding(.trailing,2)
                                Text("\(self.viewModel.lastGameFan) 番").textStyle(size: 10)
                            }
                            .padding(.horizontal,5)
                        }
                        
                        ForEach(self.viewModel.lastGameLose ) { (lose) in
                            VStack{
                                ImageView(withURL: lose.imgUrl).standardImageStyle()
                                Text("\(lose.userName ?? "")").textStyle(size: 10).frame(width: 50)
                            }
                        }
                        Spacer()
                    }.padding(.vertical,5)
                }
            }else{
                Text("No last Record")
            }
        }
        .border(Color.secondary,width: self.viewModel.lastGameDetail != nil ? 1:0)
        .padding(.horizontal,5)
    }

    
    
    func bottomArea() -> some View{
            Button(action: {
                withAnimation {
                    self.viewModel.showListView()
                }
            }) {
                Text("Switch to list View")
                    .foregroundColor(Color.black)
                    .textStyle(size: 24)
            }.padding()

    }
    
    func detail() -> some View{
        VStack{
            topView()
            lastRecordView().frame( height: 70)
            Spacer()
            mainArea()
            Spacer()
            bottomArea()
            Spacer()
        }
    }
    
    func topView() -> some View{
        HStack{
            Text("Round: \(self.viewModel.game.detailCount)")
                .titleFont(size: 24)
            Spacer()
            Button(action: {
                self.viewModel.showSwapPlayer = true
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.greenColor).frame(width: 100, height: 24)
                .overlay(
                                    Text("Swap Position")
                                        .textStyle(size: 16,color: Color.white)
                )
            }
            Button(action: {
                if self.viewModel.game.flown == 1 {
                    Utility.showAlert(message: "Game is flown")
                    return
                }
                self.viewModel.showAlert = true
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.greenColor).frame(width: 100, height: 24)
                .overlay(
                    Text("Rollback last")
                        .textStyle(size: 16,color: Color.white)
                )
            }
            .alert(isPresented: self.$viewModel.showAlert) {
                Alert(title: Text("Confirm Rollback?"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Confirm")) {
                    self.viewModel.rollback()
                    }, secondaryButton: .cancel()
                )
            }
        }.padding([.top,.horizontal])
    }
    
    var body: some View {
        VStack{
            if self.viewModel.status == .loading {
                Text("Loading")
            }else{
                detail()
            }
        }.modal(isShowing: self.$viewModel.showSwapPlayer){
            LazyView(SwapUser(game: self.viewModel.game,closeFlag:self.$viewModel.showSwapPlayer).environment(\.editMode, Binding.constant(EditMode.active)))
        }.navigationBarTitle("\(viewModel.game.date) \(viewModel.game.location)", displayMode: .inline)
    }
    
    func mainArea() -> some View {
        HStack {
            VStack {
                IndividualScoreDisplay(title:"西",player: self.viewModel.displayBoard[2])
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if self.viewModel.game.flown == 1 {
                            Utility.showAlert(message: "Game is flown")
                            return
                        }
                        self.viewModel.eat(2)
                }
            }
            VStack {
                IndividualScoreDisplay(title:"北",player: self.viewModel.displayBoard[3])
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if self.viewModel.game.flown == 1 {
                            Utility.showAlert(message: "Game is flown")
                            return
                        }
                        self.viewModel.eat(3)
                }
                Text("流局").padding()
                IndividualScoreDisplay(title:"南",player: self.viewModel.displayBoard[1])
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if self.viewModel.game.flown == 1 {
                            Utility.showAlert(message: "Game is flown")
                            return
                        }
                        self.viewModel.eat(1)
                }.padding(.top,10)
            }.padding(.horizontal)
            VStack {
                IndividualScoreDisplay(title:"東",player: self.viewModel.displayBoard[0])
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if self.viewModel.game.flown == 1 {
                            Utility.showAlert(message: "Game is flown")
                            return
                        }
                        self.viewModel.eat(0)
                }
            }
        }.padding(.top)
    }
}

