//
//  TestAddGroup.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI



struct AddPlayGroupView: View {
    
 
    @ObservedObject var viewModel: AddPlayGroupViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var tempString : String = ""
    
    init(parent : DisplayPlayGroupViewModel){
        viewModel = AddPlayGroupViewModel()
        viewModel.parent = parent
    }

    var body: some View {
        NavigationView{
            ZStack{
                Color.white.edgesIgnoringSafeArea(.vertical)
                VStack(alignment: .center){
                    TextField("Group name", text: $viewModel.groupName)
                        .padding()
                        .textFieldStyle(BottomLineTextFieldStyle())
                    playersArea
                    rule.padding()
//                    bottonButton
                    Spacer()
                }
                .background(SwiftUI.Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .navigationBarTitle("Add Group", displayMode: .inline)
        .navigationBarItems(leading: CancelButton(), trailing: ConfirmButton())
//        .navigationBarItems(leading: CancelButton())
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = UIColor.red
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
        }
    }
    
    func CancelButton() -> some View{
        
        Button(action: {
            self.viewModel.parent?.showAddingGroup.toggle()
        }) {
            Text("Cancel").foregroundColor(Color.white)
        }
    }
    
    func ConfirmButton() -> some View{
        
        Button(action: {
            self.viewModel.addGroup()
        }) {
            Text("Confirm").foregroundColor(Color.white)
        }
    }
    
    var rule : some View{
        
        VStack{
            Stepper("Start Value : \(viewModel.startFan)", value: $viewModel.startFan ,in: 0...viewModel.endFan)
            Stepper("End Value : \(viewModel.endFan)", value: $viewModel.endFan ,in: viewModel.startFan...10)
            HStack{
                Text("出沖計法")
                Spacer()
                Text("自模計法")
                Spacer()
            }
            
            ForEach(viewModel.startFan...viewModel.endFan ,id: \.self) { (index) in
                HStack{
                    Text("\(index)")
                    TextField("value", text: self.$viewModel.fan[index])
                    Text("\(index)")
                    TextField("value", text: self.$viewModel.fanSelf[index])
                }
            }
        }
    }
    

    
    var playersArea : some View {
        
            Button(action: {
                self.viewModel.showPlayerSelection.toggle()
            }) {
                HStack(alignment: .center){
                    VStack{
                        Text("\(self.viewModel.players.count)人")
                    }.padding()
                    if (self.viewModel.players.count > 3) {
                        ForEach(0...3 ,id: \.self) { (index) in
                            ImageView(withURL: self.viewModel.players[index].imgUrl).standardImageStyle()
                        }
                    }else{
                        ForEach(self.viewModel.players ,id: \.id) { (player) in
                            ImageView(withURL: player.imgUrl).standardImageStyle()
                        }
                    }
                    Spacer()
                    Image(systemName: "ellipsis")
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .scaledToFit()
                    .standardImageStyle()
                }
            }
        .sheet(isPresented: $viewModel.showPlayerSelection) {
            DisplayUserView(parent: self.viewModel)
        }
    }
}

