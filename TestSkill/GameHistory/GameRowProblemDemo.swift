//
//  TestGameRow.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import Promises

struct GameRowForDemo: View {
    
//    @ObservedObject var viewModel: GameRowViewModel
    let game : Game
    lazy var user : User? = nil
  
    
    init(game:Game){
        self.game = game
        let uid = "123"
        let temp = try?  await(User.getById(id: uid))
        self.user = temp!
        
    }
 
    
    var body: some View {
        Text("Text")
//        .onAppear(){
//            self.initial()
//        }
    }
}
