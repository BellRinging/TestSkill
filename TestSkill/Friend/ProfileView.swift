//
//  ProfileView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 12/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
   
    
    init(player : Binding<User>){
        viewModel = ProfileViewModel(player: player)
    }
    
    var body: some View {
        VStack{
            ImageView(withURL: self.viewModel.player.imgUrl).frame(width: 100, height: 100).padding()
            Text("\(self.viewModel.player.yearBalance[Utility.getCurrentYear()] ?? 0)").textStyle(size: 50,color: (self.viewModel.player.yearBalance[Utility.getCurrentYear()] ?? 0 ) > 0 ? Color.greenColor:Color.redColor).padding(.top)
            Text(self.viewModel.player.userName).textStyle(size: 20).frame(maxWidth: .infinity).padding(.top)
            Text("email: \(self.viewModel.player.email)").textStyle(size: 14).frame(maxWidth: .infinity).padding(.top)
            Text("id: \(self.viewModel.player.id)").textStyle(size: 12).frame(maxWidth: .infinity).padding(.top)
            Text("friend count: \(self.viewModel.firend.count)").textStyle(size: 20).padding(.top)
            ScrollView(.horizontal) {
                HStack{
                    ForEach(self.viewModel.firend ,id:\.self){ user in
                        VStack{
                            ImageView(withURL: user.imgUrl).standardImageStyle()
                            Text(user.userName).textStyle(size: 10).frame(width: 60)
                        }
                    }
                }
            }.padding(.top)
            if self.viewModel.showEditButton {
                Button(action: {
                    self.viewModel.deleteAccount()
                }) {
                    Rectangle().background(Color.green).cornerRadius(10)
                        .frame(width:200 , height: 40)
                        .overlay(
                            Text("Delete").textStyle(size: 16,color: Color.white)
                    )
                }
            }
            Spacer()
                .navigationBarItems(trailing:  editButton())
            .navigationBarHidden(self.viewModel.showEditPage)
        }.fullScreenCover(isPresented: self.$viewModel.showEditPage) {
            RegisterPage(closeFlag: self.$viewModel.showEditPage ,user:self.viewModel.player,userType: "dummy")
        }
    }
    
    func editButton() -> some View {
        HStack{
            if self.viewModel.player.userType == "dummy" {
                Button("Edit"){
                    withAnimation {
                        self.viewModel.showEditPage.toggle()
                    }
                }
            }else{
                Text("")
            }
        }
    }
}
