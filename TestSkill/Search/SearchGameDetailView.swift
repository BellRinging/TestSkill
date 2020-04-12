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
    
    init(closeFlag : Binding<Bool>, gameRecords: [GameRecord]){
        print("init Search Game Record View")
        viewModel = SearchGameDetailViewModel(closeFlag : closeFlag,gameRecords: gameRecords)
    }
    
    
    
    var body: some View {
        NavigationView{
            VStack{
                if (self.viewModel.gameRecords.count == 0 ) {
                    Text("No data")
                }else{
                    List(self.viewModel.gameRecords) { record in
                        GameRecordDisplayViewRow(gameRecords: record, currUser: self.viewModel.currUser, groupUser: self.viewModel.groupUser)
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Result: \(self.viewModel.gameRecords.count)", displayMode: .inline)
            .navigationBarItems(leading: cancelButton())
        }
    }
    
    
func cancelButton() -> some View {
    Button(action: {
        self.viewModel.closeFlag.toggle()
    }) {
        Image(systemName: "xmark.circle")
    }
}
        
    
    
}

