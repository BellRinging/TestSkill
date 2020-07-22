//
//  ScoreDisplay.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 29/12/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import SwiftEntryKit


struct Big2PlayerScoreCard: View {
    
    var title : String
    var player : DisplayBoardForBig2
    
 
    var body: some View {

            VStack {
            ImageView(withURL: player.imgUrl)
                .standardImageStyle().padding(.top)
            Text(player.userName)
                .textStyle(size: 12,color:Color.black)
            HStack{
                
                Text("\(player.balance)").foregroundColor(player.balance > 0  ? Color.green:Color.redColor)
                    .font(MainFont.medium.size(22))
                Text("\(player.totalCards)").textStyle(size: 12,color: Color.black)
            }
            HStack{
                Text("結牌").textStyle(size: 10).frame(width: 40,  alignment: .leading)
                Text("\(player.winCount)").textStyle(size: 10).frame(width: 30)
            }
            HStack{
                Text("被抄").textStyle(size: 10).frame(width: 40,  alignment: .leading)
                Text("\(player.doubleCount)/\(player.tripleCount)/\(player.qurdipleCount)").textStyle(size: 10).frame(width: 30)
            }
            HStack{
                Text("守尾被抄").textStyle(size: 10).frame(width: 40,  alignment: .leading)
                Text("\(player.doubleBecaseLastCount)").textStyle(size: 10).frame(width: 30)
            }
            HStack{
                Text("免抄局").textStyle(size: 10).frame(width: 40,  alignment: .leading)
                Text("\(player.safeGameCount)/\(player.lostStupidCount)").textStyle(size: 10).frame(width: 30)
            }.padding(.bottom,5)
            }.overlay(
                VStack{
                    HStack{
                        Spacer()
                        Text(title).textStyle(size: 12)
                    }.padding(.top,5)
                    Spacer()
                }
            )
        .frame(width: 100)
                .background(SwiftUI.Color.white)
                .cornerRadius(10)
                .shadow(radius: 4, x: 3, y: 3)
           
    }
    
  
}

