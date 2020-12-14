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
    
    init(balanceObj : UpperResultObject) {
        viewModel = GameUpperViewModel(balanceObj: balanceObj)
    }
    
    var body: some View {
        VStack{
            self.amountArea()
                .frame(maxWidth:.infinity)
                .padding()
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
                Text("vLY: \(self.viewModel.mtly)")
                    .textStyle(size: 10,color: Color.white)
            }
            Text("Total Balance")
                .font(.footnote)
                .foregroundColor(Color.white)
        }
    }
}
