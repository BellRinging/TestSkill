//
//  Sample.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 23/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct Sample: View {
    
    @State var showPopup = false
    
    var body: some View {
        
        Button(action: {
            self.showPopup = true
        }) {
            Text("showPopUp")
        }.sheet(isPresented: self.$showPopup) {
            SamplePopUp()
        }
        
        
        
    }
}
