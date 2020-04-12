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
    
    @Binding var user: User?
    var credit : Int
    var debit : Int
        
    var body: some View {
        VStack{
            self.amountArea(amt: "\(user?.balance ?? 0)", text: "Total Balance")
                .frame(maxWidth:.infinity)
                .padding()
            }
        .background(Color.redColor)
    }
    
    func amountArea(amt: String , text : String) -> some View{
        VStack{
            Text(amt)
                .font(.title)
                .foregroundColor(Color.white)
            Text(text)
                .font(.footnote)
                .foregroundColor(Color.white)
        }
    }
}
