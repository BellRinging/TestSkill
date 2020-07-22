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
    
    @ObservedObject var viewModel: GameUpperViewModel
    
    init(balanceObj : UpperResultObject,showPercent:Bool) {
        viewModel = GameUpperViewModel(balanceObj: balanceObj,showPercent:showPercent)
    }
    
    
    var body: some View {
        VStack{
            self.amountArea()
                .frame(maxWidth:.infinity)
                .padding()
        }.onTapGesture {
//            self.showPercent.toggle()
        }
        .background(Color.redColor)
    }
    
    func amountArea() -> some View{
        VStack{
            Text("\(self.viewModel.balance)")
                .font(.title)
                .foregroundColor(Color.white)
            HStack{
                Text("vLM: \(self.viewModel.mtlm)")
                    .textStyle(size: 10,color: Color.white)
//                    .padding([.leading,.trailing,.top])
                Text("vLY: \(self.viewModel.mtly)")
                    .textStyle(size: 10,color: Color.white)
//                    .padding([.leading,.trailing,.bottom])
            }
            Text("Total Balance")
                .font(.footnote)
                .foregroundColor(Color.white)
        }
    }
}
