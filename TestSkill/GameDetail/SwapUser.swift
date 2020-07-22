//
//  SwapUser.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 25/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI



struct SwapUser: View {
    
    
    @ObservedObject private var viewModel: SwapUserViewModel
    @State var editMode: EditMode = .active
    
    init(game : Game, closeFlag : Binding<Bool>){
        self.viewModel = SwapUserViewModel(game: game,closeFlag:closeFlag)
    }
    
    
//    func userView() -> some View{
//
//    }
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    ForEach(0..<self.viewModel.users.count){ (index) in
                        HStack{
                            VStack{
                                
                                ImageView(withURL: self.viewModel.users[index].imgUrl).standardImageStyle()
                                Text("\(self.viewModel.users[index].userName ?? "")").textStyle(size: 10).frame(width: 60)
                            }
                            Text(self.viewModel.text[index])
                        }
                        
                    }.onMove(perform: self.viewModel.move)
                }.frame(height: 350)
                Spacer()

            }
            .navigationBarTitle("Swap", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: ConfirmButton(){
                 self.viewModel.swap()
            })
            .environment(\.editMode, self.$editMode)
        }
        .navigationBarHidden(self.viewModel.closeFlag)
    }
 
}
