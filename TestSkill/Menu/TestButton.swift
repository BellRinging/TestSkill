//
//  TestButton.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 6/5/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import FloatingButton

struct TestButton: View {
    
    var body: some View {
        
        let mainButton1 = AnyView(textButton())
        let mainButton2 = AnyView(textUsingButton())
//        let mainButton1 = AnyView(textUsingButton())
        let menu1 = FloatingButton(mainButtonView: self.mainButton(), buttons: [mainButton1,mainButton2])
        .straight()
            .direction(.bottom)
            .alignment(.right)
        .spacing(10)
        .initialOffset(y: -1000)
        .animation(.spring())
        
         return NavigationView{
//            Color.black
            Text("")
                    .navigationBarTitle("test", displayMode: .inline)
         .navigationBarItems(trailing: menu1)
        }
    }

    func mainButton() -> AnyView{
        return AnyView(
            Text("  +  ").frame(width:100)
        )
    }

    
//    func textButtons3() -> SubmenuButton{
//        let view = Text("textBitton").frame(width:100)
//        return SubmenuButton(buttonView: view,action: {print("1111")}
//    }
    

}

struct textButton: View {
    var body: some View {
        Text("button1")
            .frame(width: 100, height: 50).onTapGesture {
                print("testing")
        }
    }
}

struct textUsingButton: View {
    var body: some View {
        Button(action: {
                print("testing")
        }) {
            Text("Button2")
                .foregroundColor(Color.black)
                 .frame(width: 100, height: 50)
        }
    }
}
