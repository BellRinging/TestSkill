//
//  ScoreDisplay.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 29/12/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI


struct IndividualScoreDisplay: View {
    
    var player : DisplayBoard
 
    
    var body: some View {
          
          VStack {
            Image(player.img_url)
                  .renderingMode(.original)
                  .resizable()
                  .clipShape(Circle())
                  .frame(width: 60, height: 60)
                  .scaledToFit()
            Text(player.user_name)
                  .font(.caption)
                  .fontWeight(.regular)
                  .foregroundColor(SwiftUI.Color.black)
            Text("\(player.balance)").foregroundColor(player.balance > 0  ? SwiftUI.Color.green:SwiftUI.Color.red)
                  .font(.title)
          }
          .frame(width: 100, height: 130)
          .background(SwiftUI.Color.white)
          .cornerRadius(10)
          .shadow(radius: 4, x: 3, y: 3)
                      
                  
    }
}

struct ScoreDisplay_Previews: PreviewProvider {
    
    static var previews: some View {
        IndividualScoreDisplay(player: displayBoardData[0])
        .previewLayout(.fixed(width: 110, height: 140))
    }
}
