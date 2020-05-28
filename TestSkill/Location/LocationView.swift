//
//  Location.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 28/5/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct LocationView: View {
    
    @ObservedObject var viewModel : LocationViewModel
    
    init(closeFlag : Binding<Bool>,location : Binding<String>){
        viewModel = LocationViewModel(closeFlag: closeFlag , location : location)
    }
    
    var body: some View {
        NavigationView{
            List(self.viewModel.location  ,id: \.self) { (loc) in
                Text(loc)
            }
            .navigationBarTitle("Location", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: ConfirmButton())
        }
    }
    
    func ConfirmButton() -> some View {
         Button(action: {
             self.viewModel.confirm()
         }, label:{
             Text("確認").foregroundColor(Color.white)
             
         }).padding()
             .shadow(radius: 5)
     }
}


