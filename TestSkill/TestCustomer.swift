//
//  TestCustomer.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 1/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import  SwiftEntryKit

struct TestCustomer: View {
    
    @State private var selectedPlayer = 2
    @State private var selectedFan = 3
    @State private var loserRespond = false
    
    var emptyView: some View {
        Spacer()
    }
    
    func fanSelectionItem(fan : Int) -> some View {
        Button(action: {
            self.selectedFan = fan
        }) {
            Rectangle().stroke()
                .stroke(SwiftUI.Color.black,lineWidth: 2)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle().stroke(selectedFan == fan ? SwiftUI.Color.red:SwiftUI.Color.clear, lineWidth: 4)
                        .frame(width: 35, height: 35)
            )
                .overlay(
                    Text("\(fan)")
            )
        }
    }
    
    var fanSelectionArea : some View {
        VStack{
            HStack{
                ForEach(3 ..< 7) { number in
                    self.fanSelectionItem(fan: number)
                }
            }
            HStack{
                ForEach(7 ..< 11) { number in
                    self.fanSelectionItem(fan: number)
                }
            }
        }
        
    }
    
    func playerSelectionItem(name : Int) ->some View {
        Button(action: {
            print("selected \(name)")
            self.selectedPlayer = 1
        }) {
            VStack {
                Image("player\(name)")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .scaledToFit()
                    .overlay(Circle().stroke(selectedPlayer == name ? SwiftUI.Color.red:SwiftUI.Color.clear, lineWidth: 4))
                
                Text("Player \(name)")
                    .foregroundColor(SwiftUI.Color.black)
                    .font(ChineseFont.regular.size(12))
                Text("-1024")
                    .font(.footnote)
            }
        }
    }
    
    var specialItem : some View {
        Button(action: {
            self.selectedPlayer = 5
        }) {
            VStack {
                Image("hahaha")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .scaledToFit()
                    .overlay(Circle().stroke(selectedPlayer == 5 ? SwiftUI.Color.redColor:SwiftUI.Color.clear, lineWidth: 4))
                Text("詐糊")
                    .foregroundColor(SwiftUI.Color.redColor)
                    .font(ChineseFont.regular.size(12))
                Text("-1024")
                    .font(ChineseFont.regular.size(12))
            }
        }
    }
    
    var winnerArea : some View{
   
        VStack {
      
                  Image("player1")
                      .renderingMode(.original)
                      .resizable()
                      .frame(width: 80, height: 80)
                      .clipShape(Circle())
                      .scaledToFit()
                      .overlay(Circle().stroke(selectedPlayer == 5 ? SwiftUI.Color.red:SwiftUI.Color.clear, lineWidth: 4))
              }
    }
    
    
    var buttonArea : some View{
        HStack {
            RoundedRectangle(cornerRadius: 10) .fill(SwiftUI.Color.green)
                .frame(width: 120, height: 40).overlay(         Button(action: {
                    
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
            Text("食糊啦")
                .font(ChineseFont.medium.size(24))
            self.winnerArea
            Text("邊個出沖？")
                .font(ChineseFont.regular.size(24))
            HStack{
                ForEach(2 ..< 5) { number in
                    self.playerSelectionItem(name: number)
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
    
    var body: some View {
        VStack {
       
           playerSelectionArea
           toggleArea
            .padding()
            if (loserRespond == true){
                emptyView
            }else{
                fanSelectionArea
            }
           buttonArea
        }.padding()
 
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




struct TestCustomer_Previews: PreviewProvider {
    static var previews: some View {
        TestCustomer()
        //            .previewLayout(.fixed(width: 400, height: 400))
    }
}


