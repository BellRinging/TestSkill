//
//  TestSwiftUI.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 29/12/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct TestSwiftUI: View {
    
    @EnvironmentObject private var environmentData: MyStore
    @State private var showPopUp = true
    
    var body: some View {
        HStack {
            VStack {
             
                    IndividualScoreDisplay(player: environmentData.displayBoard[0])
             
            }
            VStack {
                IndividualScoreDisplay(player: environmentData.displayBoard[1]).padding()
                Text("流局").padding()
                IndividualScoreDisplay(player: environmentData.displayBoard[2])
            }
            VStack {
                IndividualScoreDisplay(player: environmentData.displayBoard[3])
            }
        }
    }
}


struct TestSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        TestSwiftUI().environmentObject(MyStore())
    }
}
