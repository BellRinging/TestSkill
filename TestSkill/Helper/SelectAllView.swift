//
//  SelectAllView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 27/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct SelectAllView<T:Any>: View {
    
    @Binding var selectedObj : [T]
    var availableList : [T]
    var maxSelection : Int
    
    init(_ selectedObj : Binding<[T]> , availableList : [T],maxSelection: Int = 999){
        self._selectedObj = selectedObj
        self.availableList = availableList
        self.maxSelection = maxSelection
    }
    
    var body: some View {
        HStack{
            
            Button(action: {
                self.selectedObj = []
                if self.maxSelection == 999 {
                    self.selectedObj.append(contentsOf: self.availableList)
                }else{
                    for index in 0...(self.maxSelection - 1){
                        self.selectedObj.append(self.availableList[index])
                    }
                }
            }) {
                Text("Select All")
                    .textStyle(size: 12)
                    .foregroundColor(Color(.systemBlue))
            }
            Spacer()
            Button(action: {
                self.selectedObj = []
            }) {
                Text("UnSelect All")
                    .textStyle(size: 12)
                    .foregroundColor(Color(.systemBlue))
            }
        }
    }
}

