//
//  ShowUser.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 12/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Combine


struct AddFriendView: View {
    
    @ObservedObject var viewModel: FriendViewModel

    init(closeFlag : Binding<Bool> = Binding.constant(false)){
        print("init add friend View")
        viewModel = FriendViewModel(closeFlag: closeFlag)
    }

    var body: some View {
        
        NavigationView {
            VStack {
                // Search view
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("search", text: self.$viewModel.searchText, onEditingChanged: { isEditing in
                            self.viewModel.showCancelButton = true
                        }, onCommit: {
                            print("`onCommit`")
                        }).foregroundColor(.primary)
                            .autocapitalization(.none)
                        
                        Button(action: {
                            self.viewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(self.viewModel.searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                    
                        Button("Search") {
                            UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                            self.viewModel.SearchUser()
                        }
                        .foregroundColor(Color(.systemBlue))
                    
                }
                .padding([.horizontal,.top])
                .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: ConfirmButton())
                
                SelectAllView(self.$viewModel.selectedUsers, availableList: self.viewModel.users                 .filter{$0.userName.hasPrefix(self.viewModel.searchText) || $0.email.hasPrefix(self.viewModel.searchText) || self.viewModel.searchText == ""}).padding(.horizontal)
                
                HStack{
                    Image(systemName: "person.2")
                    Text("Fds now").padding(.trailing,10)
                    Image(systemName: "person.crop.circle.fill.badge.plus")               
                    Text("Pending")
                }
                
                List{
                    if self.viewModel.users.count > 0 {
                        ForEach(0...self.viewModel.users.count - 1, id:\.self) { row in
                            AddFriendRow(user: self.viewModel.users[row], isSelected: self.viewModel.selectedUsers.contains(self.viewModel.users[row]),
                                         status: self.viewModel.usersStatus[row])
                                .contentShape(Rectangle())
                                .onTapGesture {
//                                    print(self.viewModel.users[row].userName!)
                                    if  (self.viewModel.usersStatus[row] > 2){
                                        if !self.viewModel.selectedUsers.contains(self.viewModel.users[row]) {
                                            self.viewModel.selectedUsers.append(self.viewModel.users[row])
                                            }else{
                                            let index = self.viewModel.selectedUsers.firstIndex(of: self.viewModel.users[row])!
                                            self.viewModel.selectedUsers.remove(at: index)
                                        }
                                    }
                            }
                        }
                    }else{
                            Text("")
                    }
                }

            }
            .navigationBarTitle("Find Friend", displayMode: .inline)
            .resignKeyboardOnDragGesture()
        }
        
    }
    

    
    func ConfirmButton() -> some View{
        VStack{
            if self.viewModel.selectedUsers.count > 0  {
                Button(action: {
                    self.viewModel.addFriendPendding()
                }, label: {
                    Text("Add Friend").foregroundColor(Color.white)
                })
            }
        }
    }

}



                   // Filtered list of names
//                    ForEach(self.viewModel.users.filter{$0.userName!.hasPrefix(self.viewModel.searchText) || $0.email.hasPrefix(self.viewModel.searchText) || self.viewModel.searchText == ""}, id:\.self) {
//                        user in
//                        AddFriendRow(user: user, isSelected: self.viewModel.selectedUsers.contains(user))
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            print(user.userName!)
//                            if !self.viewModel.selectedUsers.contains(user){
//                                self.viewModel.selectedUsers.append(user)
//                            }else{
//                                let index = self.viewModel.selectedUsers.firstIndex(of: user)!
//                                self.viewModel.selectedUsers.remove(at: index)
//                            }
//                        }
//                    }


