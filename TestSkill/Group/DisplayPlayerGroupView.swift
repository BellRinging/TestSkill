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
    weak var parent : GameHistoryViewModel?

    
    init(parent : GameHistoryViewModel ){
        self.parent = parent
        viewModel = DisplayPlayGroupViewModel()
    }
    
    var body: some View {
         NavigationView {
            List(viewModel.groups) { group in
                self.DisplayPlayerGroupRow(group: group)
            }
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = UIColor.red
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
                .navigationBarTitle("Group", displayMode: .inline)
                .navigationBarItems(leading: CancelButton(), trailing: RightButton())
         }
    }
    
    func DisplayPlayerGroupRow(group : PlayGroup) -> some View {
        Button(action: {
            if !self.viewModel.isEditing{
                //Area that directly return
                self.parent?.groupName = group.groupName
                self.parent?.showGroupDisplay.toggle()
            }else{
                self.viewModel.selectedGroup = group
            }
        }){
            rowItem(group: group)
        }
    }
    
    func rowItem(group: PlayGroup) -> some View {
        HStack{
            Text(group.groupName)
            Spacer()
            if self.viewModel.selectedGroup == group{
                Image(systemName: "checkmark")
            }
        }
    }

    
    func CancelButton() -> some View{
        Button(action: {
            if self.viewModel.isEditing{
                self.viewModel.selectedGroup = nil
                self.viewModel.isEditing.toggle()
            }else{
                self.viewModel.isEditing.toggle()
                self.parent?.showGroupDisplay.toggle()
            }
        }, label: {
            Text("Cancel").foregroundColor(Color.white)
        })
    }
    
    func RightButton() -> some View{
        Button(action: {
            if self.viewModel.isEditing {
                //Press Confirm
                if let _ = self.viewModel.selectedGroup {
                    self.viewModel.showAddingGroup.toggle()
                    self.viewModel.isEditing.toggle()
//                    self.viewModel.selectedGroup = nil
                }else{
                    Utility.showError(message: "You must select one group")
                }
            }else{
                self.viewModel.isEditing.toggle()
            }
        }) {
            Text(viewModel.isEditing ? "Confirm":"Edit").foregroundColor(Color.white)
        }.sheet(isPresented: self.$viewModel.showAddingGroup){
            AddPlayGroupView(parent: self.viewModel)
        }
    }
    

}






