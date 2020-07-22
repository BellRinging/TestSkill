//
//  TestMenuPage.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct MenuPage: View {
    
    @ObservedObject var viewModel: MenuPageViewModel

    
    init(){
        print("init Menu")
       viewModel =  MenuPageViewModel()
    }
    
    func itemTemplate(icon:String, text:String) -> some View{
        HStack(alignment:.center){
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 25).padding(.trailing)
            Text(text)
            Spacer()
        }.padding(.horizontal)
    }
    
    var body: some View {        
        NavigationView{
            VStack{
                List(self.viewModel.items) { item in
                    self.itemTemplate(icon: item.icon, text: item.caption)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.viewModel.performAction(action: item.action)
                    }
                }
                HStack(alignment:.center){
                    Text("Term of use")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .onTapGesture {
                    withAnimation {
                        self.viewModel.isShowTerm = true
                    }
                }
                .padding()
                HStack(alignment:.center){
                    Text("App version")
                    Spacer()
                    Text("v\(self.viewModel.version)")
                }.padding()
                Spacer()
            }
            .navigationBarTitle("Menu", displayMode: .inline)
        }
        .modal(isShowing: self.$viewModel.isShowPlayGroup) {
            DisplayPlayerGroupView(closeFlag: self.$viewModel.isShowPlayGroup)
        }
            .modal(isShowing: self.$viewModel.isShowFriend ){
                DisplayFriendView(closeFlag: self.$viewModel.isShowFriend ,users:self.$viewModel.tempUser ,hasDetail: true,showSelectAll: false ,showAddButton: true)
            }
            .modal(isShowing: self.$viewModel.isShowTerm){
                Terms(closeFlag: self.$viewModel.isShowTerm)
            }
            .modal(isShowing: self.$viewModel.isShowContactUs){
                ContactUsView(closeFlag: self.$viewModel.isShowContactUs)
            }
            .modal(isShowing: self.$viewModel.isShowAccount){
                RegisterPage(closeFlag: self.$viewModel.isShowAccount ,user:self.viewModel.user)
            }
            .modal(isShowing: self.$viewModel.isShowUpdateBalance) {
                UpdateBalanceView(closeFlag: self.$viewModel.isShowUpdateBalance)
            }
        .modal(isShowing: self.$viewModel.isShowLocation) {
            LocationView(closeFlag: self.$viewModel.isShowLocation)
              }
    }
}
