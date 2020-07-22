//
//  TestSwiftUI.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 29/12/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct Big2DetailView: View {
    
    @ObservedObject private var viewModel: Big2DetailViewModel
    
    
    init(game : Game ,lastGameDetail : Big2GameDetail? ){
        viewModel = Big2DetailViewModel(game : game,lastGameDetail:lastGameDetail )
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
            mainArea()
            bottomArea()
            Spacer()
        }
    }
    
    func lastRecordView() -> some View{
        VStack{
            if self.viewModel.lastGameDetail != nil {
                ZStack(alignment: .top){
                    HStack{
                        Spacer()
                        ForEach(0..<self.viewModel.displayBoard.count , id: \.self) { (index) in
                            HStack{
                                VStack{
                                    ImageView(withURL: self.viewModel.displayBoard[index].imgUrl).standardImageStyle()
                                    Text("\(self.viewModel.displayBoard[index].userName ?? "")").textStyle(size: 10).frame(width: 50)
                                }
                                Text("\(self.viewModel.lastGameDetail!.actualNum[self.viewModel.displayBoard[index].id]!)").textStyle(size: 24,color:
                                    self.viewModel.lastGameDetail!.actualNum[self.viewModel.displayBoard[index].id]! == 0 ? Color.green :
                                        self.viewModel.lastGameDetail!.multipler[self.viewModel.displayBoard[index].id]! > 1 ? Color.redColor : Color.black)
                                
                            }
                        }
                        Spacer()
                    }.padding(.top,10)
                    .padding(.bottom,5)
                    Text("Last Record:")
                                       .foregroundColor(Color.redColor)
                        .textStyle(size: 10).padding(.top,2)
                }
              
            }else{
                Text("No last Record")
            }
        }
        .border(Color.secondary,width: self.viewModel.lastGameDetail != nil ? 1:0)
        .padding(.horizontal,5)
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
            detail()
        }
        .modal(isShowing: self.$viewModel.showSwapPlayer){
            LazyView(SwapUser(game: self.viewModel.game,closeFlag:self.$viewModel.showSwapPlayer).environment(\.editMode, Binding.constant(EditMode.active)))
        }.navigationBarTitle("\(viewModel.game.date) \(viewModel.game.location)", displayMode: .inline)
    }
    
    func mainArea() -> some View {
        HStack {
            VStack {
                Big2PlayerScoreCard(title:"3",player: self.viewModel.displayBoard[2])
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if self.viewModel.game.flown == 1 {
                            Utility.showAlert(message: "Game is flown")
                            return
                        }
                        self.viewModel.eat(2)
                }
                .overlay(
                    VStack{
                        HStack{
                            if viewModel.lastGameDetail?.winnerId == self.viewModel.displayBoard[2].id {
                                Image("first")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:23)
                            }
                            Spacer()
                        }.padding([.leading,.top],5)
                        Spacer()
                    }
                )
                
            }
            VStack {
                Big2PlayerScoreCard(title:"4",player: self.viewModel.displayBoard[3])
                    .contentShape(Rectangle()).padding(.bottom,10)
                    .onTapGesture {
                        if self.viewModel.game.flown == 1 {
                            Utility.showAlert(message: "Game is flown")
                            return
                        }
                        self.viewModel.eat(3)
                }
                .overlay(
                                   VStack{
                                       HStack{
                                           if viewModel.lastGameDetail?.winnerId == self.viewModel.displayBoard[3].id {
                                               Image("first")
                                                   .resizable()
                                                   .scaledToFit()
                                                   .frame(width:23)
                                           }
                                           Spacer()
                                       }.padding([.leading,.top],5)
                                       Spacer()
                                   }
                               )
                
                Big2PlayerScoreCard(title:"2",player: self.viewModel.displayBoard[1])
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if self.viewModel.game.flown == 1 {
                            Utility.showAlert(message: "Game is flown")
                            return
                        }
                        self.viewModel.eat(1)
                }
                .overlay(
                                   VStack{
                                       HStack{
                                           if viewModel.lastGameDetail?.winnerId == self.viewModel.displayBoard[1].id {
                                               Image("first")
                                                   .resizable()
                                                   .scaledToFit()
                                                   .frame(width:23)
                                           }
                                           Spacer()
                                       }.padding([.leading,.top],5)
                                       Spacer()
                                   }
                               )
                
            }.padding(.horizontal)
            VStack {
                Big2PlayerScoreCard(title:"1",player: self.viewModel.displayBoard[0])
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if self.viewModel.game.flown == 1 {
                            Utility.showAlert(message: "Game is flown")
                            return
                        }
                        self.viewModel.eat(0)
                }
            }
            .overlay(
                               VStack{
                                   HStack{
                                       if viewModel.lastGameDetail?.winnerId == self.viewModel.displayBoard[0].id {
                                           Image("first")
                                               .resizable()
                                               .scaledToFit()
                                               .frame(width:23)
                                       }
                                       Spacer()
                                   }.padding([.leading,.top],5)
                                   Spacer()
                               }
                           )
        }.padding(.top)
        
    
    }
}

