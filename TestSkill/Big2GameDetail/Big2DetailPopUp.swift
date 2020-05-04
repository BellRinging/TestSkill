//
//  TestCustomer.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 1/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import  SwiftEntryKit

struct Big2DetailPopUp: View {
    
    unowned var viewModel : Big2DetailViewModel
    @State public var selectedPlayer : Int = 0
    @State private var selectedNumber : [Int] = [-1,-1,-1]
    @State private var markBig2 : [Bool] = [false,false,false,false]
    
    @State private var errMessage : String = ""
    
    init(viewModel : Big2DetailViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            playerSelectionArea()
            fanSelectionArea(index: selectedPlayer)
            buttonArea
        }
        .padding()
    }
    
    func playerSelectionArea() -> some View {
        VStack{
 
                cancelButton()
            
         
            self.winnerArea()
            HStack{
                ForEach(0...2 ,id: \.self) { (index) in
                    self.playerSelectionItem(index:index)
                }
            }
        }
    }
    
    func playerSelectionItem(index : Int) ->some View {
        Button(action: {
            self.selectedPlayer = index
        }) {
            VStack {
                ImageView(withURL: self.viewModel.filteredDisplayBoard![index].img_url)
                    .ImageStyle(size: 40)
                    .overlay(Circle().stroke(selectedPlayer == index ? Color.red:Color.clear, lineWidth: 4))
                Text("\(self.viewModel.filteredDisplayBoard![index].user_name)")
                    .foregroundColor(Color.black)
                    .font(ChineseFont.regular.size(12))
                Text("($\(getAmount(who:index))) \(selectedNumber[index])")
                    .font(.footnote)
                    .foregroundColor(getAmount(who: index) > 0 ? Color.green : Color.red)
            }
        }
    }
    
    func getWinnerAmount() -> Int {
        return (getAmount(who:0) + getAmount(who:1) + getAmount(who:2)) * -1
    }
    
    func getAmount(who:Int) -> Int {
        
        for num in selectedNumber{
            if num == -1 {
                return 0
            }
        }
        var lastWinId = viewModel.lastGameDetail?.winnerId ?? "0"
        
        var list = viewModel.filteredDisplayBoard!
        list.remove(at:who)
        
        var numList = selectedNumber
        numList.remove(at:who)
        
        let player1 = viewModel.checkMultiple(num: self.selectedNumber[who], lastWin: viewModel.filteredDisplayBoard![who].id == lastWinId).1
        let player2 = viewModel.checkMultiple(num: numList[0], lastWin: list[0].id == lastWinId).1
        let player3 = viewModel.checkMultiple(num: numList[1], lastWin: list[1].id == lastWinId).1
        let value = (player1 * 3 - player2  - player3)
        return value * -1 * viewModel.amtPerCard
    }
    
    

    func fanSelectionArea(index: Int) -> some View {
        VStack{
            HStack{
                ForEach(1..<5) { number in
                    self.fanSelectionItem(fan: number,index:index)
                }
            }
            HStack{
                ForEach(5..<9) { number in
                    self.fanSelectionItem(fan: number,index:index)
                }
            }
            HStack{
                ForEach(9..<13) { number in
                    self.fanSelectionItem(fan: number,index:index)
                }
            }
            HStack{
                if self.viewModel.markBig2 {
                    Toggle(isOn: $markBig2[index]) {
                        Text("Big2").textStyle(size: 14 ,color: Color.redColor)
                    }.toggleStyle(CheckboxAtFrontToggleStyle2()).frame(width: 90)
                }else{
                    Text("").frame(width: 90)
                }
                    self.fanSelectionItem(fan: -1,index:index)
                    self.fanSelectionItem(fan: 13,index:index)
            }
        }
    }
    
    func fanSelectionItem(fan : Int , index : Int) -> some View {
        Button(action: {
            self.selectedNumber[index] = fan
        }) {
            Rectangle()
                .stroke(Color.black,lineWidth: 2)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle().stroke(self.selectedNumber[index]  == fan ? Color.red:Color.clear, lineWidth: 4)
                        .frame(width: 35, height: 35)
            )
                .overlay(
                    Text("\(fan)")
            )
        }
    }

    
    func winnerArea() ->some View{
        HStack{
            ImageView(withURL: (viewModel.winner!.img_url ))
                .ImageStyle(size: 80)
            VStack{
                Text("$\(getWinnerAmount())").textStyle(size: 30,color: Color.green).frame(width:90)
                if self.viewModel.markBig2{
                    Toggle(isOn: $markBig2[3]) {
                        Text("Big2").textStyle(size: 14 ,color: Color.redColor)
                    }.toggleStyle(CheckboxAtFrontToggleStyle2()).frame(width: 90)
                }
            }
        }
    }
    
    func cancelButton() -> some View{
        HStack{
            Button(action: {
                SwiftEntryKit.dismiss()
            }, label:{
                HStack{
                    Image(systemName: "xmark").padding(.trailing,10)
                    Spacer()
                    Text("\(errMessage)").textStyle(size: 12,color: Color.redColor)
                    Spacer()
                }
            }).accentColor(Color.red)
            Spacer()
        }
    }
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    var buttonArea : some View{
            Button(action: {
                for num in self.selectedNumber {
                    if num == -1 {
                        withAnimation{
                            self.errMessage = "Please select the card for each member"
                        }
                        return
                    }
                }
                var whoBig2 : String?
                if self.viewModel.markBig2{
                    var count = 0
                    for index in 0...3 {
                        if self.markBig2[index] {
                           count = count + 1
                            if self.markBig2[3]{
                                whoBig2 = self.viewModel.winner!.id
                            }else{
                                whoBig2 = self.viewModel.filteredDisplayBoard![index].id
                            }
                        }
                    }
                    if count > 1 {
                        self.errMessage = "2 people marked with big2"
                        return
                    }else if count < 1 {
                        self.errMessage = "Please mark who got the big2"
                        return
                    }
                }
                
                
            
                let isList = self.viewModel.filteredDisplayBoard!.map {$0.id}
                var dict = Dictionary(uniqueKeysWithValues: zip(isList,[self.getAmount(who: 0),self.getAmount(who: 1),self.getAmount(who: 2)]))
                dict[self.viewModel.winner!.id] = self.getWinnerAmount()
                var actualDict = Dictionary(uniqueKeysWithValues: zip(isList,self.selectedNumber))
                actualDict[self.viewModel.winner!.id] = 0
                
                var multiplerDict = Dictionary(uniqueKeysWithValues: zip(isList,[
                    self.viewModel.checkMultiple(num: self.selectedNumber[0], lastWin: self.viewModel.lastGameDetail?.winnerId == self.viewModel.filteredDisplayBoard![0].id).0,
                    self.viewModel.checkMultiple(num: self.selectedNumber[1], lastWin: self.viewModel.lastGameDetail?.winnerId == self.viewModel.filteredDisplayBoard![1].id).0,
                    self.viewModel.checkMultiple(num: self.selectedNumber[2], lastWin: self.viewModel.lastGameDetail?.winnerId == self.viewModel.filteredDisplayBoard![2].id).0
                    ]))
                multiplerDict[self.viewModel.winner!.id] = 1
               
                self.viewModel.saveDetail(whoWin: self.viewModel.winner!.id, actualNum: actualDict, refValue: dict, multipler: multiplerDict,whoBig2: whoBig2)
                 SwiftEntryKit.dismiss()
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

}

