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
    
    @State private var selectedPlayer : DisplayBoard? = nil
    @State private var selectedFan = 3
    @State private var loserRespond = false
    func getAmount(who:DisplayBoard) -> Int {
//
        if selectedPlayer?.id == viewModel.winner?.id {
            return -1 * (viewModel.ruleSelf[self.selectedFan] ?? 0)
        }

        if selectedPlayer?.id == who.id {
            if loserRespond {
                return -1 * 3 * (viewModel.ruleSelf[self.selectedFan] ?? 0)
            }else{
                return -1 * (viewModel.rule[self.selectedFan] ?? 0)
            }
        }else{
            return 0
        }
//        return 0
    }
    
    
    var body: some View {
        VStack {
            playerSelectionArea
            toggleArea
                .padding()
          
            fanSelectionArea
            buttonArea
        }.padding()
        
    }
    
    var emptyView: some View {
        Text("")
    }
    
    func fanSelectionItem(fan : Int) -> some View {
        Button(action: {
            self.selectedFan = fan
        }) {
            Rectangle().stroke()
                .stroke(SwiftUI.Color.black,lineWidth: 2)
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
    
    var fanSelectionArea : some View {
        VStack{
     
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
                    .foregroundColor(SwiftUI.Color.redColor)
                    .font(ChineseFont.regular.size(12))
                Text("")
                    .font(ChineseFont.regular.size(12))
            }
        }
    }
    
    var winnerArea : some View{
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
    
    
    func saveDetail(){
        let whoWin = self.viewModel.winner!.id
        let whoLose = self.selectedPlayer?.id != nil ? self.selectedPlayer!.id : ""
        let winType = self.selectedPlayer?.id == whoWin ? "Self": loserRespond ? "Special":"Other"
        let fanNo = self.selectedFan
        let byErrorFlag = self.selectedPlayer?.id == nil ? 1:0
        var value = 0
        var whoLoseList:[String] = []
        var whoWinList:[String] = []
        let repondToLose = loserRespond ? 1:0
        var winnerAmount = 0
        var loserAmount = 0
        
        if (winType == "Self" || byErrorFlag == 1){
            self.viewModel.filteredDisplayBoard.map { user in
                whoLoseList.append(user.id)
            }
            whoWinList = [whoWin]
            value = self.viewModel.ruleSelf[fanNo] ?? 0
            winnerAmount = value * 3
            loserAmount = value * -1
            if (byErrorFlag == 1){
                //swap the item
                let temp = whoWinList
                whoWinList = whoLoseList
                whoLoseList = temp
                let tem2 = winnerAmount
                winnerAmount = loserAmount
                loserAmount = tem2
            }
        }else{
            whoWinList = [whoWin]
            whoLoseList = [whoLose]
            value = loserRespond ? (self.viewModel.ruleSelf[fanNo] ?? 0 ) : (self.viewModel.rule[fanNo] ?? 0)
            winnerAmount = value
            loserAmount = value * -1
        }
        let uuid = UUID().uuidString
        let gameDetail = GameDetail(id: uuid, gameId: self.viewModel.game.id, fan: fanNo, value: value, winnerAmount: winnerAmount, loserAmount: loserAmount, whoLose: whoLoseList, whoWin: whoWinList, winType: winType ,byErrorFlag: byErrorFlag,repondToLose:repondToLose)
        gameDetail.save().then { (gameDetail)  in
//            print(gameDetail)
            print("GameRecord Saved")
            NotificationCenter.default.post(name: .updateGame, object: gameDetail.gameId)
        }.catch { (error) in
            Utility.showError(message: error.localizedDescription)
        }
    }
    
    var buttonArea : some View{
        HStack {
            RoundedRectangle(cornerRadius: 10) .fill(SwiftUI.Color.green)
                .frame(width: 120, height: 40).overlay(
                    Button(action: {
                        self.saveDetail()
                        self.dismiss()
                }, label:{
                    Text("確認")
                        .foregroundColor(SwiftUI.Color.white)
                        .font(ChineseFont.regular.size(16))
                })
                    
            )
            RoundedRectangle(cornerRadius: 10) .fill(SwiftUI.Color.red)
                .frame(width: 120, height: 40).overlay(     Button(action: {
                    self.dismiss()
                }, label:{
                    Text("取消")
                        .foregroundColor(SwiftUI.Color.white)
                        .font(ChineseFont.regular.size(16))
                    
                }))
            
        }.padding()
    }
    
    var playerSelectionArea: some View {
        VStack{
            Text("食糊啦").titleFont(size: 24)
            self.winnerArea
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
    
    var toggleArea : some View {
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
    
    func result(){
        print("\(selectedPlayer) \(selectedFan)")
    }
}

var fanSelectionView: some View {
    VStack {
        Text("番數")
            .font(.title)
    }
}
