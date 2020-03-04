//
//  ShowUser.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 12/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Promises

struct DisplayUserView: View {

    @ObservedObject var viewModel: DisplayUserViewModel
    
    
    init(flag : Binding<Bool> , users : Binding<[User]>,maxSelection : Int = 999) {
        viewModel = DisplayUserViewModel(flag: flag, users: users,maxSelection: maxSelection)
    }
    
    var body: some View {
        
        NavigationView{
            List(viewModel.users) { user in
                DisplayUserRow(user: user, isSelected: self.viewModel.selectedUser.contains(user))
                .contentShape(Rectangle())
                .onTapGesture {
                    self.viewModel.addToSelectedList(user: user)
                }
            }
            .navigationBarTitle("Display User", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(), trailing: ConfirmButton())
        }
    
    }
    
    func CancelButton() -> some View{
         Button(action: {
            self.viewModel.closeFlag.toggle()
         }, label: {
             Text("Cancel").foregroundColor(Color.white)
         })
     }
    
    func ConfirmButton() -> some View{
         Button(action: {
            self.viewModel.players = self.viewModel.selectedUser
            self.viewModel.closeFlag.toggle()
         }, label: {
             Text("Confirm").foregroundColor(Color.white)
         })
     }
}

