//
//  TestSwiftUI.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 29/12/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct SearchGameView: View {
    
    
    
    @ObservedObject private var viewModel: SearchGameViewModel
    
    init(closeFlag : Binding<Bool>, games: [Game]){
        print("init Search Game View")
        viewModel = SearchGameViewModel(closeFlag : closeFlag,games: games)
    }
    
    
    
    var body: some View {
        NavigationView{
            VStack{
                if (self.viewModel.games.count == 0 ) {
                    Text("No data")
                }else{
                    SearchGameViewListHistoryArea(sectionHeader: self.viewModel.sectionHeader, games: self.viewModel.games)
                }
                Spacer()
            }
            .navigationBarTitle("Result: \(self.viewModel.resultCount)", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag))
        }
    }
        
    
    
}

