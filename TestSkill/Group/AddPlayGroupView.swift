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
                Text("").textStyle(size: 8)
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
                
                Picker("", selection: self.$viewModel.selectedTab) {
                    Text("Mahjooh").tag(0)
                    Text("Big2").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle()).padding(.horizontal)
                if self.viewModel.selectedTab == 0 {
                    rule.padding()
                } else {
                    ruleBig2.padding()
                }
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
    
    var ruleBig2 : some View{
       VStack{
        
            Toggle(isOn: self.$viewModel.big2Enable) {
                Text("enable").textStyle(size: 14 ,color: Color.redColor)
            }.toggleStyle(CheckboxAtFrontToggleStyle())
        
        
        HStack{
          
            Text("Big2Amount").frame(minWidth:20)
            Spacer()
            TextField("value", text: self.$viewModel.big2Amt).keyboardType(.numberPad).background(Color.whiteGaryColor).cornerRadius(5).frame(width:100) .multilineTextAlignment(.center)
        }
        Toggle(isOn: self.$viewModel.enableDouble) {
            Stepper("Count 2x: \(viewModel.countDouble)", value: $viewModel.countDouble ,in: 2...viewModel.countTriple)
        }.toggleStyle(CheckboxAtFrontToggleStyle())
        Toggle(isOn: self.$viewModel.enableTriple) {
            Stepper("Count 3x: \(viewModel.countTriple)", value: $viewModel.countTriple ,in: viewModel.countDouble...viewModel.countQuadruple)
        }.toggleStyle(CheckboxAtFrontToggleStyle())
        Toggle(isOn: self.$viewModel.enableQuadiple) {
            Stepper("Count 4x: \(viewModel.countQuadruple)", value: $viewModel.countQuadruple ,in: viewModel.countTriple...13)
        }.toggleStyle(CheckboxAtFrontToggleStyle())
        Toggle(isOn: self.$viewModel.startMinusOne) {
            Text("結牌-1").frame(minWidth:20)
        }.toggleStyle(CheckboxAtFrontToggleStyle())
        Toggle(isOn: self.$viewModel.markBig2) {
            Text("Mark大Dee").frame(minWidth:20)
        }.toggleStyle(CheckboxAtFrontToggleStyle())
        
        }
    }
    
    var rule : some View{
        VStack{
            
            Toggle(isOn: self.$viewModel.mahjongEnable) {
                Text("enable").textStyle(size: 14 ,color: Color.redColor)
            }.toggleStyle(CheckboxAtFrontToggleStyle())
            
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
                    TextField("value", text: self.$viewModel.fan[index]).background(Color.whiteGaryColor).keyboardType(.numberPad).multilineTextAlignment(.center).cornerRadius(5)
                    Text("\(index)").frame(minWidth:20)
                    TextField("value", text: self.$viewModel.fanSelf[index]).background(Color.whiteGaryColor).keyboardType(.numberPad).multilineTextAlignment(.center).cornerRadius(5)
                }
            }
            Toggle(isOn: self.$viewModel.enableBonusPerDraw) {
                HStack{
                    Text("Bonus per draw").frame(minWidth:20)
                    Spacer()
                    TextField("value", text: self.$viewModel.bonusPerDraw).keyboardType(.numberPad).background(Color.whiteGaryColor).cornerRadius(5).frame(width:100) .multilineTextAlignment(.center)
                }
            }.toggleStyle(CheckboxAtFrontToggleStyle())
            
            Toggle(isOn: self.$viewModel.enableSpecialItem) {
                HStack{
                    Text("Special Item").frame(minWidth:20)
                    Spacer()
                    TextField("value", text: self.$viewModel.specialItemAmount).keyboardType(.numberPad).background(Color.whiteGaryColor).cornerRadius(5).frame(width:100) .multilineTextAlignment(.center)
                }
            }.toggleStyle(CheckboxAtFrontToggleStyle())
            
            Toggle(isOn: self.$viewModel.enableCalimWater) {
                Stepper("Claim Water Fan: \(viewModel.calimWaterFan)", value: $viewModel.calimWaterFan ,in: viewModel.startFan...viewModel.endFan)
            }.toggleStyle(CheckboxAtFrontToggleStyle())
            HStack{
                Text("Claim Water Amt")
                Spacer()
                TextField("value", text: self.$viewModel.calimWaterAmount).keyboardType(.numberPad).background(Color.whiteGaryColor).cornerRadius(5).frame(width:100) .multilineTextAlignment(.center)
            }.padding(.trailing , 5)
            
        }
    }
    

    
  
}

