//
//  GameDetailListView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 8/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import SwiftEntryKit

struct GameDetailListView: View {
    
    @ObservedObject private var viewModel: GameDetailListViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    init(game : Game ){
        viewModel = GameDetailListViewModel(game: game )
    }
    
    var body: some View {
        NavigationView{
            VStack{
                self.titleRow(self.viewModel.users).padding(.top , 50)
                self.totleRow(self.viewModel.totals).padding(.top)
                List{
                    if self.viewModel.gameForDisplay.count > 0 {
                        ForEach(0...viewModel.gameForDisplay.count - 1 ,id: \.self) { (index) in
                            self.row(self.viewModel.gameForDisplay[index] , index:index)
                        }
                    }else{
                        HStack{
                            Spacer()
                        Text("No records")
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle("Match Record", displayMode: .inline)
            .navigationBarItems(leading: cancelButton())
        }
        .onAppear(){
            self.viewModel.loadGameDetail()
        }
    }
    
    func titleRow(_ users : [User]) -> some View{
        HStack{
            ForEach(users ,id: \.self) { (user) in
                UserDisplay(user: user).frame(minWidth: 70, maxWidth: .infinity)
            }
        }.padding(.leading, 80)
    }
   
    
    func totleRow(_ list : [Int]) -> some View{
        HStack{
           Text("TTL")
                .frame(minWidth: 35)
                .padding([.leading,.trailing] , 10)
            ForEach(list ,id: \.self) { item in
                Text("\(item)")
                    .bold()
                    .frame(minWidth: 70, maxWidth: .infinity)
            }
        }.padding([.leading,.trailing] , 5)
    }

    func row(_ list : [String],index:Int) -> some View{
        HStack{
            Circle()
                .fill(Color.greenColor)
                .frame(minWidth: 25)
                .padding([.leading,.trailing] , 10)
                .overlay(
                    Text("\(index + 1)").foregroundColor(Color.white)
                )
            ForEach(list ,id: \.self) { item in
                Text(item)
                    .frame(minWidth: 70, maxWidth: .infinity)
                    .foregroundColor(Int(item) ?? 0  == 0 ? Color.black : Int(item) ?? 0 > 0 ? Color.green : Color.red)
            }
        }.padding([.leading,.trailing] , 5)
    }
    
    func cancelButton() -> some View {
            Button(action: {
                SwiftEntryKit.dismiss()
            }) {
                  Text("Close")
            }
        }
    
}
