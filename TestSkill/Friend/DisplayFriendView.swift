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
    
    init(closeFlag : Binding<Bool> , users : Binding<[User]> ,maxSelection : Int = 999 ,includeSelfInReturn : Bool = true , onlyInUserGroup : Bool = false,hasDetail : Bool = false,acceptNoReturn : Bool = false , showSelectAll : Bool = true,showAddButton:Bool = false,includeSelfInSeletion:Bool = false) {
        viewModel = DisplayFriendViewModel(closeFlag: closeFlag, users: users,maxSelection: maxSelection ,includeSelfInReturn : includeSelfInReturn,onlyInUserGroup:onlyInUserGroup,hasDetail: hasDetail,acceptNoReturn:acceptNoReturn,showSelectAll:showSelectAll,showAddButton:showAddButton,includeSelfInSeletion:includeSelfInSeletion)
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
                List(viewModel.users) { user in
                    self.rowLogic(user:user)
           
                }
            }
            .navigationBarTitle("Display Friend", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: CButton())
        }.modal(isShowing: self.$viewModel.showAddFriend) {
            AddFriendView(closeFlag: self.$viewModel.showAddFriend)
        }.modal(isShowing: self.$viewModel.showFriendRequest) {
            FriendRequestView(closeFlag: self.$viewModel.showFriendRequest)
        }.modal(isShowing: self.$viewModel.showAddDummyFriend) {
            RegisterPage(closeFlag: self.$viewModel.showAddDummyFriend ,userType: "dummy")
        }
    }
    
    func rowLogic(user:User) -> some View{
        VStack{
            if self.viewModel.hasDetail == false {
                DisplayFriendRow(user: user, isSelected: self.viewModel.selectedUser.contains(user))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.viewModel.addToSelectedList(user: user)
                }
            }else{
                NavigationLink(destination:LazyView(ProfileView(player: user))){
                    DisplayFriendRow(user: user,isSelected:false)
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
                    .cancel { print("Cancel")},
                    .default(Text("Add Dummy Friend"),action: {self.viewModel.showAddDummyFriend = true}),
                    .default(Text("Search by Network"),action: {self.viewModel.showAddFriend = true}),
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

