//
//  FlownGameView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct UpdateBalanceView: View {
    
        @ObservedObject var viewModel : UpdateBalanceViewModel
    
    
    init(closeFlag : Binding<Bool>){
        viewModel = UpdateBalanceViewModel(closeFlag: closeFlag)
    }
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                ForEach(0..<self.viewModel.years.count) { index in
                    Text("Your \(self.viewModel.years[index]) Balance :").textStyle(size: 16).padding()
                    Text(self.viewModel.amtForDisplay[index])
                        .titleFont(size: 30,color: Color.greenColor)
                        .padding(.bottom)
                    TextField("Modify the Amount here", text: self.$viewModel.amtForEdit[index])
                        .autocapitalization(.none)
                        .cornerRadius(10)
                        .background(Color.whiteGaryColor)
                        .frame(maxWidth:100)
                        .frame(height:60)
                }
                Text("Remark: There may be error in sync the balance , the function manual adject the correct balance manual into your account").lineLimit(nil).fixedSize(horizontal: false, vertical: true).padding([.top,.horizontal],20)
                Spacer()
            }
                
            .navigationBarTitle("Upldate Balance", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: ConfirmButton(){ self.viewModel.showAlert = true})
        }
        .alert(isPresented: self.$viewModel.showAlert) {
            Alert(title: Text("Confirm?"), message: Text("balance will update"), primaryButton: .destructive(Text("Update")) {
                self.viewModel.confirm()
                }, secondaryButton: .cancel()
            )
        }
    }
    
    
    func userView(user : User) -> some View{
        VStack{
            ImageView(withURL: user.imgUrl).standardImageStyle()
            Text("\(user.userName ?? "")").textStyle(size: 10).frame(width: 70)
        }.padding(.horizontal)
    }


}

