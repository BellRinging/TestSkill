//
//  samplePopUp.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 23/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct SamplePopUp: View {
    
        
    var body: some View {
        VStack{
            ForEach((1...5), id: \.self) { id in
                SamplePopUpRow(rowId: id)
            }
        }
    }
}


struct SamplePopUpRow: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var rowId : Int
    var body: some View {
        HStack{
            Button(action: {
                print("dismiss")
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Row \(self.rowId)")
            }
        }
    }
}
