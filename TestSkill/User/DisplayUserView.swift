//
//  ShowUser.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 12/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Promises

struct DisplayFriendView: View {

    @ObservedObject var viewModel: DisplayUserViewModel
    
    init(flag : Binding<Bool> , users : Binding<[User]>,maxSelection : Int = 999 ,includeSelf : Bool = true) {
        viewModel = DisplayUserViewModel(flag: flag, users: users,maxSelection: maxSelection ,includeSelf : includeSelf)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                SelectAllView(self.$viewModel.selectedUser, availableList: self.viewModel.users)
                    .padding([.horizontal,.top])
                List(viewModel.users) { user in
                    DisplayUserRow(user: user, isSelected: self.viewModel.selectedUser.contains(user))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.viewModel.addToSelectedList(user: user)
                    }
                }
            }
            .navigationBarTitle("Display User", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: ConfirmButton())
        }
    
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

