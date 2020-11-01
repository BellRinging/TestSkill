//
//  TestAddGroup.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Introspect


struct ResultView: View {
    
    @ObservedObject var viewModel: ResultViewModel
    
    init(closeFlag : Binding<Bool> ){
        viewModel = ResultViewModel(closeFlag: closeFlag)
    }
    
    func titleRow() -> some View{
        HStack{
            Text("")
                .frame(width: 70)
            Text("Year Bal")
                .textStyle(size: 10)
                .frame(width: 120)
                Text("Win/Game      Percent")
            .textStyle(size: 10)
                .frame(width: 100)
        }
    }
    
    func row(result : resultObj) -> some View{
        HStack{
            UserDisplay(user: result.user)
            Text("\(result.yearBalance)")
                .textStyle(size: 24,color: result.yearBalance > 0 ? Color.greenColor:Color.redColor)
                .frame(width: 100)
            VStack{
                HStack{
                    Text("\(result.winCount)/\(result.numberOfGame)")
                        .textStyle(size: 16)
                        .frame(width: 50)
                    Text("\(result.winPercent)")
                        .textStyle(size: 16)
                        .frame(width: 50)
                }
                HStack{
                    ForEach(result.last6GameResult ,id:\.self){ win in
                        
                        Text("\(win)")
                            .textStyle(size: 16,color: win == "W" ? Color.redColor:Color.blue)
                    }
                }
            }
        }
    }

    var body: some View {
        NavigationView{
            List{
               
                titleRow().overlay(
                    HStack{
                        Button(action: {
                            self.viewModel.showSelect = true
                        }) {
                            Text("Up to : \(self.viewModel.selectedPeriod)").textStyle(size: 14)
                        }
                        Spacer()
                    }
                )
                ForEach(0..<self.viewModel.result.count , id:\.self){ index in
                    HStack{
                        Circle()
                            .fill(Color.greenColor)
                            .frame(width: 25,height: 25)
                            .padding([.leading,.trailing] , 5)
                            .overlay(
                                Text("\(index + 1)").foregroundColor(Color.white)
                        )
                        self.row(result : self.viewModel.result[index])
                    }
                    
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag))
        }.fullScreenCover(isPresented: self.$viewModel.showSelect) {
            PlayerSelectionView(returnItem: self.$viewModel.selectedPeriod,closeFlag: self.$viewModel.showSelect)
        }.onAppear(){
            self.viewModel.selectedPeriod = Utility.getCM()
        }
    }

  
}

