//
//  TestMenuPage.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct MenuPage: View ,Equatable {
    static func == (lhs: MenuPage, rhs: MenuPage) -> Bool {
        return true
    }
    
    
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
                }.listStyle(PlainListStyle())
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
                VStack{
                    EmptyView()
                        .fullScreenCover(isPresented: self.$viewModel.isShowAccount){
                            LazyView(RegisterPage(closeFlag: self.$viewModel.isShowAccount ,user:self.viewModel.user).equatable())
                        }
                    EmptyView()
                        .fullScreenCover(isPresented: self.$viewModel.isShowUpdateBalance) {
                            UpdateBalanceView(closeFlag: self.$viewModel.isShowUpdateBalance)
                        }
                    EmptyView()
                        .fullScreenCover(isPresented: self.$viewModel.isShowContactUs){
                            ContactUsView(closeFlag: self.$viewModel.isShowContactUs)
                        }
                    EmptyView()
                        .fullScreenCover(isPresented: self.$viewModel.isShowTerm){
                            Terms(closeFlag: self.$viewModel.isShowTerm)
                        }
                    EmptyView()
                        .fullScreenCover(isPresented:  self.$viewModel.isShowFriend ){
                            DisplayFriendView(option: DisplayFriendViewOption(closeFlag: self.$viewModel.isShowFriend ,users:self.$viewModel.tempUser ,hasDetail: true,showSelectAll: false ,showAddButton: true))
                        }
                    EmptyView()
                        .fullScreenCover(isPresented:self.$viewModel.isShowPlayGroup) {
                            DisplayPlayerGroupView(closeFlag: self.$viewModel.isShowPlayGroup)
                        }
                    EmptyView()
                        .fullScreenCover(isPresented: self.$viewModel.isShowLocation) {
                            LazyView(LocationView(closeFlag: self.$viewModel.isShowLocation).equatable())
                        }
                }
            }
            .navigationBarTitle("Menu", displayMode: .inline)       
        }
    }
     
}
