//
//  TestFont.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 3/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import Promises

struct TestFont: View {
    
    var viewModel = TestFontViewModel()
    
    init(){
        print("TestFont")
    }
      
    var body: some View {
        
        VStack{
            
            Button(action: {
                     self.viewModel.deleteGroup()
                     }) {
                         Text("Delete Group")
                     }

            Button(action: {
                        self.viewModel.deleteUserRecords()
                        }) {
                            Text("Delete gameRecords")
                        }

            Button(action: {
                self.viewModel.DeleteGame()
            }) {
                Text("Delete Game")
            }
            Button(action: {
                self.viewModel.deleteGameDetail()
                }) {
                    Text("Delete Game Detail")
                }

            Button(action: {
                self.viewModel.deleteUserBalanceAndItem()
                }) {
                    Text("Delete User Record and Balance")
                }

        }

        
    }
    
    
    
    
}

