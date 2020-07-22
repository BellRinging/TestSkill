
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
    
    
    func normalView() -> some View{
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
    }
    
    
    func lastRecordView() -> some View{
        VStack{
            if self.viewModel.lastGameDetail != nil {
                if self.viewModel.lastGameDetail?.winType == "draw" {
                    VStack{
                        Text(self.viewModel.lastGameDetail == nil ? "" :"Last Record:")
                            .foregroundColor(Color.redColor)
                            .textStyle(size: 10)
                        Spacer()
                        Text("~Draw Game~").textStyle(size: 24).frame(maxWidth:.infinity)
                        Spacer()
                    }.padding(.vertical,5)
                }else if self.viewModel.lastGameDetail?.winType == "Special" {
                        HStack{
                            Spacer()
                            Text(self.viewModel.lastGameDetail == nil ? "" :"Last Record:")
                                                   .foregroundColor(Color.redColor)
                                                   .textStyle(size: 10)
                            ForEach(self.viewModel.lastGameLose ) { (lose) in
                                VStack{
                                    ImageView(withURL: lose.imgUrl).standardImageStyle()
                                    Text("\(lose.userName ?? "")").textStyle(size: 10).frame(width: 50)
                                }
                            }
                            Text("Special").textStyle(size: 24)
                            Text("\(self.viewModel.lastGameDetail?.loserAmount ?? 0)").textStyle(size: 24,color: Color.red)
                            Spacer()
                        }.padding(.vertical,5)
                }else{
                    normalView()
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
            if self.viewModel.game.flown == 0{
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
        }.sheet(isPresented:self.$viewModel.showSpecialView){
            LazyView(MarkSpecialView(closeFlag: self.$viewModel.showSpecialView, game: self.viewModel.game))
        }.modal(isShowing: self.$viewModel.showSwapPlayer){
            LazyView(SwapUser(game: self.viewModel.game,closeFlag:self.$viewModel.showSwapPlayer).environment(\.editMode, Binding.constant(EditMode.active)))
        }.navigationBarTitle("\(viewModel.game.date) \(viewModel.game.location)", displayMode: .inline)
    }
    
    func bonusText()-> some View {
        VStack{
            HStack{
                if self.viewModel.enableBonusPerDraw && self.viewModel.game.flown != 1{
                    Text("Bonus:").textStyle(size: 12).padding(.top,10)
                }
                Spacer()
                if self.viewModel.enableSpecialItem && self.viewModel.game.flown != 1{
                    Button(action: {
                        self.viewModel.showSpecialView = true
                    }){
                        Text("Spacial").textStyle(size: 12).padding(.top,10)
                    }
                }
            }
            HStack{
                if self.viewModel.enableBonusPerDraw && self.viewModel.game.flown != 1{
                    Text("\(self.viewModel.game.bonus ?? 0)" ).textStyle(size: 18,color: Color.greenColor).padding(.leading,5)
                }
                Spacer()
                Text("Mark By:").textStyle(size: 10).padding(.top,5)
            }
            HStack{
                if self.viewModel.enableCalimWater && self.viewModel.game.flown != 1{
                    Text("Water:").textStyle(size: 12).padding(.top,5)
                }
                Spacer()
              Text(self.viewModel.owner).textStyle(size: 10,color:Color.redColor).padding(.top,5)
            }
            HStack{
                if self.viewModel.enableCalimWater && self.viewModel.game.flown != 1{
                    Text("\(self.viewModel.game.water ?? 0)").textStyle(size: 18,color: Color.greenColor).padding(.leading,5)
                }
                Spacer()
                
            }
            Spacer()
        }
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
                Button(action: {
                    if self.viewModel.game.flown == 1 {
                        Utility.showAlert(message: "Game is flown")
                        return
                    }
                    if !self.viewModel.enableBonusPerDraw {
                        Utility.showAlert(message: "No bonus enable")
                        return
                    }
                    Utility.showAlert(message: "Confirm draw game?",callBack: self.viewModel.markDraw)
                }) {
                    Text("流局").textStyle(size: 14)
                        .padding()
                }
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
        .overlay(
            bonusText()
        )
    }
}

