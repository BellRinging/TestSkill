//
//  TestAddGroup.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct TestAddGame: View {
    
    @State private var gameDate = ""
    @State private var location = ""
    
    
//    @State private var fan : [String] = ""
    @State private var fan : [String] = ["","","","","","","","","","","","","","","",""]
    @State private var fanSelf : [String] = ["","","","","","","","","","","","","","","",""]
       let textColor =  SwiftUI.Color.init(red: 29/255, green: 29/255, blue: 29/255)
       let whiteGaryColor = SwiftUI.Color.init(red: 242/255, green: 243/255, blue: 244/255)
       let redColor = SwiftUI.Color.init(red: 225/255, green: 0/255, blue: 0/255)
    
    
    init(){
//        body.accentColor(whiteGaryColor).padding()
    }
    
    var body: some View {
        
        HStack {
            NavigationView{
                        ZStack{
                            whiteGaryColor.edgesIgnoringSafeArea(.vertical)
                            VStack{
                                VStack(alignment: .center){
                                    TextField("Date", text: $gameDate)
                                        .padding()
                                        .textFieldStyle(BottomLineTextFieldStyle())
                                    TextField("Location", text: $location)
                                        .padding()
                                        .textFieldStyle(BottomLineTextFieldStyle())
                                    
                                    
                                    Button(action: {
                                        
                                    }) {
                                        HStack{
                                            Image("player1")
                                                .renderingMode(.original)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                                .scaledToFit()
                                            Image("player2")
                                                .renderingMode(.original)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                                .scaledToFit()
                                            Image("player3")
                                                .renderingMode(.original)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                                .scaledToFit()
                                            Spacer()
                                            Text("Players")
                                        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                    }
                                }.background(SwiftUI.Color.white)
                                    .padding(.trailing, 10)
                                    .padding(.leading, 10)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(SwiftUI.Color.green)
                                    .frame(width: UIScreen.main.bounds.width - 50, height: 40)
                                    .overlay(
                                        Button(action: {
                                        }, label:{
                                            Text("確認").foregroundColor(SwiftUI.Color.white)
                                            
                                        })
                                        )
                                    .padding()
                                    .shadow(radius: 5)
                            }
                        }
                        .navigationBarTitle("Add Game", displayMode: .inline)
                        .background(NavigationConfigurator { nc in
                            nc.navigationBar.barTintColor = UIColor.red
                            nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                        })
            }
        }
        
    }
                    
                                    
                           
                               

                            
                            
                           
                            
                        
                        
    
    
      
}


struct TestAddGame_Previews: PreviewProvider {
    static var previews: some View {
        TestAddGame()
    }
}
