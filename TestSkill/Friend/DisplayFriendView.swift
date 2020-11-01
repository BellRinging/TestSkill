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

    @ObservedObject var viewModel: DisplayFriendViewModel
    
    init(option : DisplayFriendViewOption) {
        viewModel = DisplayFriendViewModel(option:option)
    }
    
    

    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Button(action: {
                        if self.viewModel.requestList.count > 0 {
                            self.viewModel.showFriendRequest = true
                        }
                    }, label: {
                        Text("Fds Request : \(self.viewModel.requestList.count)").padding()
                    })
                    if self.viewModel.showSelectAll {
                        SelectAllView(self.$viewModel.selectedUser, availableList: self.viewModel.users,maxSelection: self.viewModel.maxSelection)
                            .padding([.horizontal,.top])
                    }
                }
                List(0..<self.viewModel.users.count ,id:\.self) { index in
                    self.rowLogic(user:self.$viewModel.users[index])
           
                }.listStyle(PlainListStyle())
                navigationArea
            }
            .navigationBarTitle("Display Friend", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: CButton())
        }
    }
    
    var navigationArea : some View{
        VStack{
            EmptyView()
                .fullScreenCover(isPresented:  self.$viewModel.showAddFriend) {
                    AddFriendView(closeFlag: self.$viewModel.showAddFriend)
                }
            EmptyView()
                .fullScreenCover(isPresented:self.$viewModel.showFriendRequest) {
                    FriendRequestView(closeFlag: self.$viewModel.showFriendRequest)
                }
            EmptyView()
                .fullScreenCover(isPresented: self.$viewModel.showAddDummyFriend) {
                    LazyView(RegisterPage(closeFlag: self.$viewModel.showAddDummyFriend ,userType: "dummy").equatable())
                }
            
        }
    }
    
    func rowLogic(user:Binding<User>) -> some View{
        VStack{
            if self.viewModel.hasDetail == false {
                DisplayFriendRow(user: user.wrappedValue, isSelected: self.viewModel.selectedUser.contains(user.wrappedValue))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.viewModel.addToSelectedList(user: user.wrappedValue)
                }
            }else{
                NavigationLink(destination:LazyView(ProfileView(player: user))){
                    DisplayFriendRow(user: user.wrappedValue,isSelected:false)
                }
            }
        }
        
    }
    

    func AddButton() -> some View{
        Button(action: {
            self.viewModel.showPopOver = true
        }) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 20,height: 20)
        }
        .actionSheet(isPresented: self.$viewModel.showPopOver) {
            ActionSheet(
                title: Text("Friend Type"),
                buttons: [
                    .cancel { },
                    .default(Text("Add Dummy Friend"),action: { withAnimation {self.viewModel.showAddDummyFriend = true}}),
                    .default(Text("Search by Network"),action: {withAnimation {self.viewModel.showAddFriend = true}}),
                ]
            )
        }
     }

    func CButton() -> some View{
        HStack{
            if (self.viewModel.showAddButton){
                AddButton()
            }else{
                 Text("")
            }
            if (self.viewModel.acceptNoReturn || self.viewModel.users.count > 0 && self.viewModel.selectedUser.count > 0){
                ConfirmButton(){
                    self.viewModel.confirm()
                }
            }else{
                Text("")
            }
        }
    }
}

