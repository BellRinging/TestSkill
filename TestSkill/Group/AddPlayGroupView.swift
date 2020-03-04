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
    
    init(parent : DisplayPlayGroupViewModel){
        viewModel = AddPlayGroupViewModel()
        viewModel.parent = parent
    }

    var body: some View {
        NavigationView{
            VStack(alignment: .center){
                TextField("Group name", text: $viewModel.groupName)
                    .padding()
                    .textFieldStyle(BottomLineTextFieldStyle())
                AddPlayGroupPlayerRow(players: viewModel.players)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        self.viewModel.showPlayerSelection.toggle()
                    }
                }
                rule.padding()
                Spacer()
            }
            .navigationBarTitle("Add Group", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(), trailing: ConfirmButton())
        }.modal(isShowing: self.$viewModel.showPlayerSelection) {
            DisplayUserView(flag: self.$viewModel.showPlayerSelection, users: self.$viewModel.players)
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
    

    
  
}

