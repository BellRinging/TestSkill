//
//  SwapUser.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 25/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI



struct PlayerSelectionView: View {
    
    
    @ObservedObject private var viewModel: PeriodSelectionViewModel
    
    init(returnItem : Binding<String>, closeFlag : Binding<Bool>){
        self.viewModel = PeriodSelectionViewModel(returnItem: returnItem,closeFlag:closeFlag)
    }
    
    
    var body: some View {
        NavigationView{
            
                List{
                    ForEach(0..<self.viewModel.items.count){ (index) in
                        
                           
                            Text(self.viewModel.items[index])
                                .onTapGesture {
                                    self.viewModel.confirm(index:index)
                        }
                        
                        
                    }
                }
                

            
            .navigationBarTitle("Period Selection", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag))
        }
        .navigationBarHidden(self.viewModel.closeFlag)
    }
 
}
