//
//  TestSwiftUI.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 29/12/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct SearchGameDetailView: View {
    
    @ObservedObject private var viewModel: SearchGameDetailViewModel
    
    init(closeFlag : Binding<Bool>, gameDetails: [GameDetail],refUser: User?){
        viewModel = SearchGameDetailViewModel(closeFlag: closeFlag,gameDetails: gameDetails ,refUser: refUser)
    }
    
    
    
    var body: some View {
        NavigationView{
            VStack{
                if (self.viewModel.gameDetails.count == 0 ) {
                    Text("No data")
                }else{
                    List {
                        ForEach(self.viewModel.sectionHeader, id: \.self) { gameId in
                            Section(header: self.sectionArea(text:gameId)) {
                                ForEach(self.viewModel.displayResult[gameId]! ,id: \.id) { gameDetail in
                                    SearchGameDetailRow(gameDetail: gameDetail , refUser: self.viewModel.refUser)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Result: \(self.viewModel.gameDetails.count)", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag))
        }
    }
    
    func sectionArea(text : String) -> some View {
        HStack{
            Text("\(self.viewModel.sectionHeaderString[text]!)").textStyle(size: 12)
            Spacer()
        }
    }
}


    
    
