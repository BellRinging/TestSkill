//
//  TestGameRow.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct TestGameRow: View {
    
    @State private var selectedPlayer = 0
    @State private var win = true
    var textColor: SwiftUI.Color {
            return SwiftUI.Color.init(red: 29/255, green: 29/255, blue: 29/255)
          }
    
    var greenColor: SwiftUI.Color {
      return SwiftUI.Color.init(red: 6/255, green: 126/255, blue: 65/255)
    }
    
     let redColor = SwiftUI.Color.init(red: 225/255, green: 0/255, blue: 0/255)
    
    var body: some View {
        HStack{
            VStack{
                Text("6/12/2019")
                    .font(MainFont.medium.size(16))
                    .foregroundColor(textColor)
                Text("Hei Home")
                    .font(MainFont.light.size(14))
                    .foregroundColor(textColor)
                }.padding()
            Image("player1")
                               .renderingMode(.original)
                               .resizable()
                               .frame(width: 40, height: 40)
                               .clipShape(Circle())
                               .scaledToFit()
                               .overlay(Circle().stroke(selectedPlayer == 0 ? SwiftUI.Color.red:SwiftUI.Color.clear, lineWidth: 4))
            Image("player2")
                               .renderingMode(.original)
                               .resizable()
                               .frame(width: 40, height: 40)
                               .clipShape(Circle())
                               .scaledToFit()
                               .overlay(Circle().stroke(selectedPlayer == 1 ? SwiftUI.Color.red:SwiftUI.Color.clear, lineWidth: 4))
            Image("player3")
                               .renderingMode(.original)
                               .resizable()
                               .frame(width: 40, height: 40)
                               .clipShape(Circle())
                               .scaledToFit()
                               .overlay(Circle().stroke(selectedPlayer == 2 ? SwiftUI.Color.red:SwiftUI.Color.clear, lineWidth: 4))
            Spacer()
            Text("3170")
                .font(MainFont.forTitleText())
                .foregroundColor(win ? greenColor:redColor)
        }.padding()
    }
}

struct TestGameRow_Previews: PreviewProvider {
    static var previews: some View {
        TestGameRow()
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 70))
    }
}
