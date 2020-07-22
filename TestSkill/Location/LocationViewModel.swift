//
//  LocationViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 28/5/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//
import Foundation
import SwiftUI
import SwiftEntryKit

class LocationViewModel : ObservableObject {
    
    @Published var locations : [Location] = []
    @Published var selectedItem : String = ""
    var selectedIndex : Int = 0
    @Binding var closeFlag : Bool
    @Published var showAddButton : Bool = true
    @Published var showingDeleteAlert : Bool = false
    @Binding var refLocation : String
    var selectedForAction : Location?
    @Published var showsAlert : Bool = false
    @Published var isShowAddAlert : Bool = false
    @Published var textContent : String = ""
    
//    var acceptNoReturn : Bool = false
    var singleSelect : Bool = false
    
    
    
    
    init(closeFlag : Binding<Bool>,location : Binding<String> , singleSelect : Bool){
        self._closeFlag = closeFlag
        self._refLocation = location
        self.singleSelect = singleSelect
        self.loadLocation()
    }
    
    func loadLocation(){
          let uid = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!.id
        Location.getItemByUserId(userId:uid).then { locations in
            self.locations = locations
        }.catch{ err in
            Utility.showAlert(message: err.localizedDescription)
        }
    }
    
    func confirm(){
        self.refLocation = selectedItem
        self.closeFlag = false
    }
    
    func add(){
        withAnimation{
            let id = UUID().uuidString
            let uid = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!.id
            let loc = Location(id: id, name: textContent ,userId: uid)
            loc.save().then { loc2 in
                self.locations.append(loc2)
            }.catch { (err) in
                Utility.showAlert(message: err.localizedDescription)
            }
        }
    }
    
    func edit(index : Int){
        
        var loc = self.locations[index]
        loc.name = textContent
        loc.save().then { loc2 in
            self.locations[index] = loc 
            print("edited")
        }.catch { (err) in
            Utility.showAlert(message: err.localizedDescription)
        }
    }

    func delete(){
        withAnimation{
            if let selectedForAction = selectedForAction {
                selectedForAction.delete().then { _ in
                    let temp = self.locations.firstIndex { $0.id == selectedForAction.id}!
                    self.locations.remove(at: temp)
                }.catch { (err) in
                    Utility.showAlert(message: err.localizedDescription)
                }
            }
        }
    }
    
}
