//
//  ChatDetailViewModel.swift
//  QBChat-MVVM
//
//  Created by Paul Kraft on 30.10.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine
import SwiftUI

class DisplayPlayGroupViewModel: ObservableObject {

    private var tickets: [AnyCancellable] = []
    @Binding var closeFlag : Bool
    @Binding var returnGroup : PlayGroup?
    var needReturn : Bool = true
    @Published var groups : [PlayGroup] = []
    @Published var showAddingGroup: Bool = false
    @Published var selectedGroup : PlayGroup? = nil{
        didSet{
            if let index = resolveIndex(){
                selectedIndex = index
            }
        }
    }
    
    func resolveIndex() -> Int?{
        if selectedGroup != nil{
            return self.groups.firstIndex(of: self.selectedGroup!)
        }
        return  nil
    }
    
    var isAdd : Bool = true
    
    var selectedIndex : Int = 0
    @Published var showingDeleteAlert : Bool = false
    
    init(closeFlag : Binding<Bool> , returnGroup: Binding<PlayGroup?> ,needReturn: Bool ){
        self._closeFlag = closeFlag
        self._returnGroup = returnGroup
        self.needReturn = needReturn
        loadGroup()
        addObservor()
    }
    
    func addObservor(){
        NotificationCenter.default.publisher(for: .addPlayGroup)
            .map{$0.object as! PlayGroup}
            .sink { [unowned self] (group) in
                let index = self.groups.firstIndex { $0.id == group.id }
                if let index = index {
                    self.groups.remove(at: index)
                    self.groups.append(group)
                }else{
                    self.groups.append(group)
                }
        }.store(in: &tickets)
    }
    
    func deleteGroup(index : Int){
        let group = groups[selectedIndex]
        if let currentGroup = UserDefaults.standard.retrieve(object: PlayGroup.self, fromKey: UserDefaultsKey.CurrentGroup){
            if currentGroup.id == group.id{
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.CurrentGroup)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.CurrentGroupUser)
            }
        }
        
        group.delete().then { _ in
            self.groups.remove(at: self.selectedIndex)
        }
        
    }
    
    func loadGroup(){
        PlayGroup.getUserGroup().then { (groups)  in
            if (groups.count > 0) {
                self.selectedGroup = groups[0]
            }
            self.groups = groups
        }.catch({ (err) in
            Utility.showAlert(message: err.localizedDescription)
        })

    }
    

}
