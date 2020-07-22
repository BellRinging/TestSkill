//
//  ShowUser.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 12/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Combine


struct FriendRequestView: View {
    
    @ObservedObject var viewModel: FriendRequestViewModel

    init(closeFlag : Binding<Bool> = Binding.constant(false)){
        viewModel = FriendRequestViewModel(closeFlag: closeFlag)
    }

    var body: some View {
        NavigationView {
            List(self.viewModel.users) { user in
                DisplayFriendRow(user: user, isSelected: self.viewModel.selectedUsers.contains(user))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.viewModel.addToSelectedList(user: user)
                }
            }
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: CButton())
            .navigationBarTitle("Display Friend", displayMode: .inline)
        }
    }
    
    func CButton() -> some View{
        VStack{
            if self.viewModel.selectedUsers.count > 0  {
                ConfirmButton(){
                    self.viewModel.addFriend()
                }
            }
        }
    }

}

