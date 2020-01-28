//
//  TestFont.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 3/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct TestFont: View {
    
    
    var body: some View {
        VStack{
            Button(action: {
                self.printFont()
                }) {
                    Text("Font")
            }
            
            Text("Simple Swift Guide").font(MainFont.bold.size(14))
            Text("Simple Swift Guide").font(SwiftUI.Font.custom("KohinoorDevanagari-Regular", size: 33))
        }
        
    }
    
    
    
    
    func printFont(){
//        for fontFamily in UIFont.familyNames {
//            for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
//                print("\(fontName)")
//            }
//        }
        
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        

    
        NotificationCenter.default.post(name: .dismissMainView ,object: nil)
        print("Logout")
        
    }
}

struct TestFont_Previews: PreviewProvider {
    static var previews: some View {
        TestFont()
    }
}
