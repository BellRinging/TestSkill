//
//  FlownGameView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct MarkFlownView: View ,Equatable {
    static func == (lhs: MarkFlownView, rhs: MarkFlownView) -> Bool {
        return true
    }
    
    
    @ObservedObject var viewModel : MarkFlownViewModel
    
    
    
    init(closeFlag : Binding<Bool>,game : Game){
        viewModel = MarkFlownViewModel(closeFlag: closeFlag,game:game)
    }
    
    var body: some View {
        NavigationView{
            VStack{
            VStack{
                ForEach(0..<self.viewModel.players.count  ,id: \.self) { (index) in
                    HStack{
                        self.userView(user: self.viewModel.players[index])
                        TextField("Result:", text: self.$viewModel.playersAmtInString[index])
                            .autocapitalization(.none)
                            .frame(width: 100)
                    }
                }
                HStack{
                    Text("Water : ").textStyle(size: 18)
                    Text("\(self.viewModel.game.water ?? 0)")
                        .textStyle(size: 18,color: Color.redColor)
                    Text("balance : ")
                        .textStyle(size: 18)
                    Text("\(self.viewModel.balanceLeft ?? 0)")
                        .textStyle(size: 18,color: Color.redColor)
                }
                Spacer()
            }.padding(.top)
        }
            .navigationBarTitle("Flown Game Result", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: ConfirmButton(){self.viewModel.showAlert = true})
        }
        .alert(isPresented: self.$viewModel.showAlert) {
            Alert(title: Text("Game Flown Confirm?"), message: Text("Game cant be edit after flown?"), primaryButton: .destructive(Text("Flown")) {
                self.viewModel.confirm()
                }, secondaryButton: .cancel()
            )
        }
    }
    
    func userView(user : User) -> some View{
        VStack{
            ImageView(withURL: user.imgUrl).standardImageStyle()
            Text("\(user.userName )").textStyle(size: 10).frame(width: 70)
        }.padding(.horizontal)
    }

}

