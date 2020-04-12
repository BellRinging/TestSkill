//
//  ScoreDisplay.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 29/12/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import SwiftEntryKit


struct IndividualScoreDisplay: View {
    
    var title : String
    var player : DisplayBoard
    
 
    var body: some View {
          VStack {
            Text(title).textStyle(size: 12)
            ImageView(withURL: player.img_url).standardImageStyle()
            Text(player.user_name)
                .font(ChineseFont.regular.size(12))
                  .foregroundColor(SwiftUI.Color.black)
            Text("\(player.balance)").foregroundColor(player.balance > 0  ? Color.green:Color.redColor)
                  .font(MainFont.medium.size(24))
          }
          .frame(width: 100, height: 130)
          .background(SwiftUI.Color.white)
          .cornerRadius(10)
          .shadow(radius: 4, x: 3, y: 3)
    }
    
  
}

