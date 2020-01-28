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
    
    var player : DisplayBoard
 
    
    var body: some View {
        Button(action: {
            self.eat()
        }, label:{
          VStack {
            Image(player.img_url)
                  .renderingMode(.original)
                  .resizable()
                  .clipShape(Circle())
                  .frame(width: 60, height: 60)
                  .scaledToFit()
            Text(player.user_name)
                .font(ChineseFont.regular.size(12))
                  .foregroundColor(SwiftUI.Color.black)
            Text("\(player.balance)").foregroundColor(player.balance > 0  ? SwiftUI.Color.green:SwiftUI.Color.redColor)
                  .font(MainFont.medium.size(24))
          }
          .frame(width: 100, height: 130)
          .background(SwiftUI.Color.white)
          .cornerRadius(10)
          .shadow(radius: 4, x: 3, y: 3)
        })
                  
    }
    
    func eat(){
        print("\(self.player.user_name) 食糊啦")
        // Customized view
        let customView = UIHostingController(rootView: TestCustomer())
        
//        let customView = UIView()

            
            
        /*
        Do some customization on customView
        */

        // Attributes struct that describes the display, style, user interaction and animations of customView.
        var attributes = EKAttributes()
        
   attributes.windowLevel = .normal
        attributes.position = .center
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .forward
        attributes.entryInteraction = .forward
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        

     attributes.positionConstraints.size = .init(width: .offset(value: 50), height: .intrinsic)

     let edgeWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
     attributes.positionConstraints.maxSize = .init(width: .constant(value: edgeWidth), height: .intrinsic)
        
        attributes.roundCorners = .all(radius: 10)
        
        SwiftEntryKit.display(entry: customView, using: attributes)
        
    }
}



struct ScoreDisplay_Previews: PreviewProvider {
    
    static var previews: some View {
        IndividualScoreDisplay(player: displayBoardData[0])
        .previewLayout(.fixed(width: 110, height: 140))
    }
}
