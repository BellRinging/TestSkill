//
//  TestCustomer.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 1/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import  SwiftEntryKit

struct GameDetailPopUp: View {
    
    unowned var viewModel : GameDetailViewModel
    @State public var selectedPlayer : DisplayBoard? {
        didSet{
            if self.selectedPlayer == nil {
                self.showFanArea = false
                self.selectedFan = self.viewModel.endFan
            }else{
                self.showFanArea = true
            }
        }
    }
    
    @State private var selectedFan : Int = 999
    @State private var loserRespond = false
    @State private var showFanArea = true
    
    init(viewModel : GameDetailViewModel){
        self.viewModel = viewModel
//        self.selectedFan = viewModel.startFan
    }
    
    var body: some View {
        VStack {
            cancelButton()
            playerSelectionArea()
            toggleArea()
                .padding()
            if showFanArea {
                fanSelectionArea
            }
            buttonArea
        }
        .padding()
        .onAppear(){
            self.selectedPlayer = self.viewModel.filteredDisplayBoard[0]
        }
        
    }
    
    func playerSelectionArea() -> some View {
        VStack{
            Text("食糊啦").titleFont(size: 24)
            self.winnerArea()
            Text("邊個出沖？")
                .font(ChineseFont.regular.size(24))
            HStack{
                ForEach(0...2 ,id: \.self) { (index) in
                    self.playerSelectionItem(board:self.viewModel.filteredDisplayBoard[index])
                }
                specialItem
            }
        }
    }
    
    func playerSelectionItem(board : DisplayBoard) ->some View {
        Button(action: {
            self.selectedPlayer = board
        }) {
            VStack {
                ImageView(withURL: board.img_url)
                    .ImageStyle(size: 40)
                    .overlay(Circle().stroke(selectedPlayer?.id == board.id ? Color.red:Color.clear, lineWidth: 4))
                Text("\(board.user_name)")
                    .foregroundColor(Color.black)
                    .font(ChineseFont.regular.size(12))
                Text("\(getAmount(who:board))")
                    .font(.footnote)
                    .foregroundColor(getAmount(who:board) > 0 ? Color.green : Color.red)
            }
        }
    }
    
    func getAmount(who:DisplayBoard) -> Int {
        
        if selectedPlayer == nil {
            return (viewModel.ruleSelf[viewModel.endFan] ?? 0)
        }
        
        if selectedPlayer?.id == viewModel.winner?.id {
            return -1 * (viewModel.ruleSelf[self.selectedFan] ?? 0)
        }
        
        if selectedPlayer?.id == who.id {
            return  loserRespond ? -1 * 3 * (viewModel.ruleSelf[self.selectedFan] ?? 0) : -1 * (viewModel.rule[self.selectedFan] ?? 0)
        }else{
            return 0
        }
        
    }

    var fanSelectionArea : some View {
        VStack{
            if (viewModel.seperateLineForFan){
                HStack{
                    ForEach(viewModel.startFan ..< (viewModel.startFan + 4) ) { number in
                        self.fanSelectionItem(fan: number)
                    }
                }
                HStack{
                    ForEach((viewModel.startFan + 4) ..< viewModel.endFan + 1) { number in
                        self.fanSelectionItem(fan: number)
                    }
                }
            }else{
                HStack{
                    ForEach(viewModel.startFan ..< viewModel.endFan + 1) { number in
                        self.fanSelectionItem(fan: number)
                    }
                }
            }
        }
    }
    
    func fanSelectionItem(fan : Int) -> some View {
        Button(action: {
            self.selectedFan = fan
        }) {
            Rectangle()
                .stroke(Color.black,lineWidth: 2)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle().stroke(selectedFan == fan ? Color.red:Color.clear, lineWidth: 4)
                        .frame(width: 35, height: 35)
            )
                .overlay(
                    Text("\(fan)")
            )
        }
    }

    
    var specialItem : some View {
        Button(action: {
            self.selectedPlayer = nil
        }) {
            VStack {
                Image("hahaha")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .scaledToFit()
                    .overlay(Circle().stroke(selectedPlayer == nil ? Color.redColor:Color.clear, lineWidth: 4))
                Text("詐糊")
                    .foregroundColor(Color.redColor)
                    .font(ChineseFont.regular.size(12))
                Text("")
                    .font(ChineseFont.regular.size(12))
            }
        }
    }
    
    func winnerArea() ->some View{
        ZStack {
            HStack{
                Spacer()
                if (self.selectedPlayer?.id == self.viewModel.winner?.id ){
                    Image("self")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width:35).padding(.trailing,40)
                }
            }
            ImageView(withURL: (viewModel.winner!.img_url ))
                .ImageStyle(size: 80)
                .overlay(Circle().stroke(selectedPlayer?.id ==  viewModel.winner?.id ? Color.redColor:Color.clear, lineWidth: 4)).onTapGesture {
                    self.selectedPlayer = self.viewModel.winner
            }
            
        }
    }
    
    func cancelButton() -> some View{
        HStack{
            Button(action: {
                self.dismiss()
            }, label:{
                Image(systemName: "xmark")
            }).accentColor(Color.red)
            Spacer()
        }
    }
    
    
    var buttonArea : some View{
            Button(action: {
                if self.selectedFan == 999 {
                    Utility.showAlert(message: "Please select the fan")
                    return
                }
                let loserRe = self.loserRespond ? 1 : 0
                let winType = self.selectedPlayer?.id == self.viewModel.winner?.id ? "Self" :"Other"
                let byError = self.selectedPlayer?.id == nil ? 1: 0
                let fan = self.selectedFan
                self.viewModel.saveDetail(whoWin: self.viewModel.winner!.id, whoLose: self.selectedPlayer?.id  ?? "", winType: winType, fan: fan, loserRespond: loserRe, byErrorFlag: byError)
                self.dismiss()
            }, label:{
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(Color.green)
                        .frame( height: 40)
                    Text("確認")
                        .foregroundColor(SwiftUI.Color.white)
                        .font(ChineseFont.regular.size(16))
                }
            }).padding()
    }
    
   
    
    func toggleArea() -> some View {
        HStack{
            Spacer()
            Text("輸家包自摸")
                .font(ChineseFont.regular.size(16))
            Toggle(isOn: $loserRespond) {
                Text("dummyTest")
            }.labelsHidden().frame(width: 80, height: 20)
            Spacer()
        }
    }

    func dismiss(){
        SwiftEntryKit.dismiss()
    }

}

var fanSelectionView: some View {
    VStack {
        Text("番數")
            .font(.title)
    }
}
