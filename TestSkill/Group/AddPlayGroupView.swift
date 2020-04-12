//
//  TestAddGroup.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Introspect


struct AddPlayGroupView: View {
    
    @ObservedObject var viewModel: AddPlayGroupViewModel
    
    init(closeFlag : Binding<Bool> , editGroup : Binding<PlayGroup?> = Binding.constant(nil)){
        viewModel = AddPlayGroupViewModel(closeFlag: closeFlag, editGroup: editGroup)
    }

    var body: some View {
        NavigationView{
            ScrollView{
            VStack(alignment: .center){
                TextField("Group name", text: $viewModel.groupName)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }
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
            }
            .keyboardResponsive()
            .navigationBarTitle(self.viewModel.editGroup == nil ? "Add Game Group" : "Edit Game Group", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: ConfirmButton())
        }.modal(isShowing: self.$viewModel.showPlayerSelection) {
            DisplayFriendView(closeFlag: self.$viewModel.showPlayerSelection, users: self.$viewModel.players)
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
                    Text("\(index)").frame(minWidth:20)
                    TextField("value", text: self.$viewModel.fan[index]).background(Color.whiteGaryColor).cornerRadius(5)
                    Text("\(index)").frame(minWidth:20)
                    TextField("value", text: self.$viewModel.fanSelf[index]).background(Color.whiteGaryColor).cornerRadius(5)
                }
            }
        }
    }
    

    
  
}

