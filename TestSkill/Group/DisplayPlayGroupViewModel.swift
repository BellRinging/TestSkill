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

    @Binding var closeFlag : Bool
    @Binding var returnGroup : PlayGroup?
    
    
    init(closeFlag : Binding<Bool> , returnGroup : Binding<PlayGroup?>){
        self._closeFlag = closeFlag
        self._returnGroup = returnGroup
        loadGroup()
    }
    
    @Published var groups : [PlayGroup] = []
    @Published var showAddingGroup: Bool = false
    @Published var isEditing: Bool = false
    @Published var selectedGroup : PlayGroup? = nil
    
    func loadGroup(){
//        Utility.showProgress()
        PlayGroup.getAllItem().then { (groups)  in
            self.groups = groups
        }.catch({ (err) in
            Utility.showError(message: err.localizedDescription)
        })
//            .always {
//            Utility.hideProgress()
//        }
    }
    

}
