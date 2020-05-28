//
//  FlownGameView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct MarkSpecialView: View {
    
    @ObservedObject var viewModel : MarkSpecialViewModel
    
    
    init(closeFlag : Binding<Bool>,game : Game){
        viewModel = MarkSpecialViewModel(closeFlag: closeFlag,game:game)
    }
    
    var body: some View {
        NavigationView{
            HStack{
                ForEach(0..<self.viewModel.players.count  ,id: \.self) { (index) in
                    VStack{
                        Spacer()
                        IndividualScoreDisplayForSpecial(user: self.viewModel.players[index],amount: self.viewModel.playersAmt[index])
                            .offset( y: CGFloat(self.viewModel.playersOffset[index]))
                            .onTapGesture {
                                withAnimation {
                                    self.viewModel.updatePosition(playerIndex: index)
                                }
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Mark Special", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: ConfirmButton())
        }
    }
    

    func ConfirmButton() -> some View {
        Button(action: {
            self.viewModel.markSpecial()
        }, label:{
            Text("確認").foregroundColor(Color.white)
            
        }).padding()
            .shadow(radius: 5)
    }

}

struct IndividualScoreDisplayForSpecial: View {
    
    var user : User
    var amount : Int

    var body: some View {
        VStack {
            ImageView(withURL: user.imgUrl)
                .standardImageStyle()
            Text(user.userName)
                .textStyle(size: 12)
            Text("\(amount)")
                .textStyle(size: 14,color: amount > 0 ? Color.greenColor : Color.redColor)
                .frame(width:60)
        }
        .frame(width: 70, height: 130)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4, x: 3, y: 3)
    }
    
    
}

