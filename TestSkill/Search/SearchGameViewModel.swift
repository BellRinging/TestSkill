//
//  ChatDetailViewModel.swift
//  QBChat-MVVM
//
//  Created by Paul Kraft on 30.10.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth
import Promises
import SwiftEntryKit
import SwiftUI
import Firebase


class SearchGameViewModel: ObservableObject {
    

    
//    lazy var background: DispatchQueue = {
//        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
//    }()
//    
    @Published var games: [String:[Game]] =  [:]
    @Published var sectionHeader : [String] = []
    @Published var status : pageStatus = .loading
    @Binding var closeFlag : Bool

    
    
    init(closeFlag : Binding<Bool>,games :[Game]) {
        print("init search game")
        self._closeFlag = closeFlag
        let sorted = games.sorted { $0.date > $1.date }
        let dictionary = Dictionary(grouping: sorted) { $0.period }
        self.sectionHeader = dictionary.keys.sorted(by: >)
        self.games = dictionary
     
    }
    
   
}
