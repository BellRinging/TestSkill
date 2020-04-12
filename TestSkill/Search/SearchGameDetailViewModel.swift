//
//  ChatDetailViewModel.swift
//  QBChat-MVVM
//
//  Created by Paul Kraft on 30.10.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase


class SearchGameDetailViewModel: ObservableObject {
    
    @Published var gameRecords: [GameRecord]
    @Binding var closeFlag : Bool
    var currUser : User
    var groupUser : [User]
    
    init(closeFlag : Binding<Bool>,gameRecords :[GameRecord]) {
        self._closeFlag = closeFlag
        self.gameRecords = gameRecords
        self.groupUser = []
        if let groupUser2 = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser){
            self.groupUser = groupUser2
        }else{
            Utility.showAlert(message: "Fail to get the user group")
        }
        self.currUser = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
    }
}
