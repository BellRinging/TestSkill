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
    
    init(player : User){
        viewModel = ProfileViewModel(player: player)
    }
    
    var body: some View {
        VStack{
            ImageView(withURL: self.viewModel.player.imgUrl).frame(width: 100, height: 100).padding()
            Text("\(self.viewModel.player.balance)").textStyle(size: 50,color: self.viewModel.player.balance > 0 ? Color.greenColor:Color.redColor)
            Text(self.viewModel.player.userName).textStyle(size: 20).frame(maxWidth: .infinity)
            Text("email: \(self.viewModel.player.email)").textStyle(size: 14).frame(maxWidth: .infinity)
            Text("id: \(self.viewModel.player.id)").textStyle(size: 12).frame(maxWidth: .infinity)
            Text("friend count: \(self.viewModel.firend.count)").textStyle(size: 20)
            ScrollView(.horizontal) {
                HStack{
                    ForEach(self.viewModel.firend ,id:\.self){ user in
                        VStack{
                            ImageView(withURL: user.imgUrl).standardImageStyle()
                            Text(user.userName).textStyle(size: 10).frame(width: 60)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}
