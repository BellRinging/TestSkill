//
//  Location.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 28/5/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import UIKit
import SwiftEntryKit

struct LocationView: View ,Equatable{
    
    static func == (lhs: LocationView, rhs: LocationView) -> Bool {
        return true
    }
    
    
    @ObservedObject var viewModel : LocationViewModel
    
    init(closeFlag : Binding<Bool>,location : Binding<String> = Binding.constant("") ,singleSelect : Bool = false){
        print("init Location")
        viewModel = LocationViewModel(closeFlag: closeFlag , location : location,singleSelect: singleSelect)
    }
    
    var body: some View {
        NavigationView{
            List{
                ForEach(self.viewModel.locations ,id: \.id) { loc in
                    LocationRow(text:loc.name,isSelected : self.viewModel.selectedItem  == loc.name )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.viewModel.selectedItem = loc.name
                            if self.viewModel.singleSelect {
                                self.viewModel.refLocation = loc.name
                                self.viewModel.closeFlag.toggle()
                            }
                    }
                    .contextMenu{
                        self.popUpMenu(loc: loc)
                    }
                }
                .onDelete { (index) in
                    self.viewModel.selectedForAction = self.viewModel.locations[index.first!]
                    self.viewModel.showingDeleteAlert = true
                }
                
            }.listStyle(PlainListStyle())
            .navigationBarTitle("Location", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: CButton())
        }
        .alert(isPresented: self.$viewModel.showingDeleteAlert) {
            Alert(title: Text("Confirm delete"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                self.viewModel.delete()
                }, secondaryButton: .cancel()
            )
        }
    }
    
    func CButton() -> some View{
           HStack{
               if (self.viewModel.showAddButton){
                   AddButton()
               }else{
                    Text("")
               }
        }
       }


    func AddButton() -> some View{
        Button(action: {

            let popup = CustomAlertWithTextField(title: "Add Location", returnText: self.$viewModel.textContent){
                self.viewModel.add()
            }
            let customView = UIHostingController(rootView: popup)
            var attributes = EKAttributes()
            attributes.windowLevel = .normal
            attributes.position = .center
            attributes.displayDuration = .infinity
            attributes.screenInteraction = .forward
            attributes.entryInteraction = .forward
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
            attributes.positionConstraints.size = .init(width: .offset(value: 50), height: .intrinsic)
            let edgeWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
            attributes.positionConstraints.maxSize = .init(width: .constant(value: edgeWidth), height: .intrinsic)
            attributes.roundCorners = .all(radius: 10)
            SwiftEntryKit.display(entry: customView, using: attributes)
        }) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 20,height: 20)
        }
     }
    
    
    func popUpMenu(loc: Location) -> some View{
        VStack {
            Button(action: {
                self.viewModel.selectedForAction = loc
                self.viewModel.textContent = loc.name
                let index = self.viewModel.locations.firstIndex { $0.id == loc.id }!
                let popup = CustomAlertWithTextField(title: "Edit Location", returnText: self.$viewModel.textContent){
                    self.viewModel.edit(index:index)
                }
                    
                
                let customView = UIHostingController(rootView: popup)
                var attributes = EKAttributes()
                attributes.windowLevel = .normal
                attributes.position = .center
                attributes.displayDuration = .infinity
                attributes.screenInteraction = .forward
                attributes.entryInteraction = .forward
                attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
                attributes.positionConstraints.size = .init(width: .offset(value: 50), height: .intrinsic)
                let edgeWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
                attributes.positionConstraints.maxSize = .init(width: .constant(value: edgeWidth), height: .intrinsic)
                attributes.roundCorners = .all(radius: 10)
                SwiftEntryKit.display(entry: customView, using: attributes)
                
            }){
                HStack {
                    Text("Edit")
                    Image(systemName: "lock")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth : 20)
                }
            }
            Button(action: {
                self.viewModel.selectedForAction = loc
                self.viewModel.delete()
            }){
                HStack {
                    Text("Remove")
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth : 20)
                }
            }
        }
    }
}




