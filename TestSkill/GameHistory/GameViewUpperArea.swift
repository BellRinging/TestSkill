//
//  GameViewUpperArea.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 18/2/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//


import SwiftUI
import Combine

struct GameViewUpperArea: View {
    
//    @ObservedObject var viewModel: GameViewModel
    
    init(){
//        print("recreate game header")
    }
        
    var body: some View {
        VStack{
            self.amountArea(amt: "1003", text: "6月結餘")
            HStack{
                Spacer()
                self.amountArea(amt: "1003", text: "6月收入")
                Spacer()
                self.amountArea(amt: "1003", text: "6月支出")
                Spacer()
            }.padding()
            
        }.background(Color.redColor)
    }
    
    func amountArea(amt: String , text : String) -> some View{
        VStack{
            Text(amt)
                .font(.title)
                .foregroundColor(SwiftUI.Color.white)
            Text(text)
                .font(.footnote)
                .foregroundColor(SwiftUI.Color.white)
        }
    }
}
