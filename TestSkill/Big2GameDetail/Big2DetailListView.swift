//
//  Big2.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 14/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import SwiftEntryKit

struct Big2DetailListView: View {
    
    @ObservedObject private var viewModel: Big2DetailListViewModel
        
    init(game:Game){
        viewModel = Big2DetailListViewModel(game:game)
    }
        
    func cancelButton() -> some View {
        Button(action: {
            SwiftEntryKit.dismiss()
        }) {
            Text("Close")
        }
    }
        
    var topArea : some View{
  
        HStack(alignment: .top){
            Button(action: {
                self.viewModel.showAccumulateValue.toggle()
                          }) {
                              RoundedRectangle(cornerRadius: 10)
                                  .fill(Color.greenColor).frame(width: 100, height: 24)
                              .overlay(
                                Text(self.viewModel.showAccumulateValue ? "actual" : "accumulate")
                                                      .textStyle(size: 16,color: Color.white)
                              )
            }.padding([.leading,.top])
            Spacer()
            if self.viewModel.user.count > 0 {
                ForEach(0...self.viewModel.user.count - 1 ,id: \.self) { (index) in
                    VStack{
                        ImageView(withURL: self.viewModel.user[index].imgUrl).standardImageStyle()
                        Text(self.viewModel.user[index].userName).textStyle(size: 10)
                    }.frame(width:40)
                }
            }
        }.padding(.trailing,5)
         
    }
    
    
    func leftItem(index:Int,index2:Int) -> some View {
        Rectangle()
            .foregroundColor(self.viewModel.leftItemColor[index][index2])
            .frame(width: 30 )
            .overlay( Text("\(self.viewModel.leftHistory[index][index2])").textStyle(size: 12,color: self.viewModel.leftFontColor[index][index2]))
            .padding([.horizontal,.vertical],0)
    }
    
    func item2(index:Int,index2:Int) -> some View {
                Rectangle()
                    .foregroundColor(self.viewModel.itemColor[index][index2])
                    .frame(width: 45 )
                    .overlay( Text("\(self.viewModel.history[index][index2])").textStyle(size: 12,color: self.viewModel.fontColor[index][index2]))
                    .padding([.horizontal,.vertical],0)
    }
    
    func itemAccumulate(index:Int,index2:Int) -> some View {
        Rectangle()
            .foregroundColor(self.viewModel.itemColor[index][index2])
            .frame(width: 45 )
            .overlay( Text("\(self.viewModel.accumulateValue[index][index2])").textStyle(size: 12,color: self.viewModel.fontColor[index][index2]))
            .padding([.horizontal,.vertical],0)
    }
    
    var body: some View {
          NavigationView{
            VStack(alignment: .leading, spacing: 5){
                topArea.padding(.top , 50)
                ScrollView(.vertical){
                    VStack(alignment: .leading, spacing: 1){
                        ForEach(0..<self.viewModel.history.count  , id:\.self){ index in
                            HStack{
                                HStack(alignment: .bottom, spacing: 1){
                                    ForEach(0...3 , id:\.self){ i in
                                     self.leftItem(index:index,index2:i)
                                    }
                                }.padding(.horizontal,5)
                                Text("\(index + 1)").textStyle(size: 14)
                                    .frame(width: 30)
                                Spacer()
                                HStack(alignment: .bottom, spacing: 1){
                                    
                                    ForEach(0...3 , id:\.self){ i in
                                        VStack{
                                        if self.viewModel.showAccumulateValue {
                                            self.itemAccumulate(index:index,index2:i)
                                        }else{
                                            self.item2(index:index,index2:i)
                                        }
                                        }
                                    }
                                    
                                }.padding(.trailing,5)
                            } .padding(.vertical,0)
                            
                        }
                    }
                }
            }
            .navigationBarTitle("Match Record", displayMode: .inline)
            .navigationBarItems(leading: cancelButton())
        }
    }
}

