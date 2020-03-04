//
//  ShowUser.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 12/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Promises


struct DisplayPlayerGroupView: View {
    
    @ObservedObject var viewModel: DisplayPlayGroupViewModel


    
    init(closeFlag : Binding<Bool> ,returnGroup : Binding<PlayGroup?>){
        viewModel = DisplayPlayGroupViewModel(closeFlag: closeFlag, returnGroup: returnGroup)
    }
    
    var body : some View {
         NavigationView {
            List(viewModel.groups) { group in
                DisplayPlayerGroupRow(group: group, isSelected: self.viewModel.selectedGroup == group)
                .contentShape(Rectangle())
                .onTapGesture {
                    if !self.viewModel.isEditing{
                        self.viewModel.returnGroup = group
                        UserDefaults.standard.save(customObject: group, inKey: UserDefaultsKey.CurrentGroup)
                        print("Save")
                        self.viewModel.closeFlag.toggle()
                    }else{
                        self.viewModel.selectedGroup = group
                    }
                }
            }
            .navigationBarTitle("Group", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(), trailing: RightButton())
         }
         .modal(isShowing: self.$viewModel.showAddingGroup) {
             AddPlayGroupView(parent: self.viewModel)
        }
       
    }
    
    func CancelButton() -> some View{
        Button(action: {
            if self.viewModel.isEditing{
                self.viewModel.selectedGroup = nil
            }else{
                withAnimation {
                    self.viewModel.closeFlag.toggle()
                }
            }
            self.viewModel.isEditing.toggle()
        }, label: {
            Text("Cancel").foregroundColor(Color.white)
        })
    }
    
    func RightButton() -> some View{
        Button(action: {
            if self.viewModel.isEditing {
                //Press Confirm
                if let selectedGroup = self.viewModel.selectedGroup {
                    withAnimation {
                        self.viewModel.showAddingGroup.toggle()
                    }
                }else{
                    Utility.showError(message: "You must select one group")
                }
            }else{
                self.viewModel.isEditing.toggle()
            }
        }) {
            Text(viewModel.isEditing ? "Confirm Edit":"Edit").foregroundColor(Color.white)
        }
    }
}






