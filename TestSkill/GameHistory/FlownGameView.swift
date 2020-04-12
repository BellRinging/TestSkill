//
//  FlownGameView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct FlownGameView: View {
    
        @ObservedObject var viewModel : FlownGameViewModel
    
    
    init(closeFlag : Binding<Bool>,game : Game){
        viewModel = FlownGameViewModel(closeFlag: closeFlag,game:game)
    }
    
    var body: some View {
        
        NavigationView{
       
            if self.viewModel.player1 == nil || self.viewModel.player2 == nil || self.viewModel.player3 == nil || self.viewModel.player4 == nil {
                Text("loading")
            }else{
                VStack{
                    HStack{
                        userView(user: self.viewModel.player1!)
                        TextField("Result1", text: self.$viewModel.player1Amt)
                            .autocapitalization(.none)
                            .frame(width: 100)
                    }
                    HStack{
                        userView(user: self.viewModel.player2!)
                        TextField("Result2", text: self.$viewModel.player2Amt)
                            .autocapitalization(.none)
                            .frame(width: 100)
                    }
                    HStack{
                        userView(user: self.viewModel.player3!)
                        TextField("Result3", text: self.$viewModel.player3Amt)
                            .autocapitalization(.none)
                            .frame(width: 100)
                    }
                    HStack{
                        userView(user: self.viewModel.player4!)
                        TextField("Result4", text: self.$viewModel.player4Amt)
                            .autocapitalization(.none)
                            .frame(width: 100)
                    }
                    Spacer()
                    
                }
                .navigationBarTitle("Flown Game Result", displayMode: .inline)
                .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: ConfirmButton())
            }
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
    

    func ConfirmButton() -> some View {
        Button(action: {
            self.viewModel.showAlert = true
        }, label:{
            Text("確認").foregroundColor(Color.white)
            
        }).padding()
            .shadow(radius: 5)
    }

}

