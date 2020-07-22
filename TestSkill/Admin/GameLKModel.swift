//
//  SearchViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 18/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import FirebaseAuth

class GameLKModel: ObservableObject {
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()

    @Published var games : [Game] = []
    
    init() {
        self.background.async {
            
            self.loadGame()
        }
    }
    
    
    func loadGame(){
        Game.getAllItem().then{ games in
            
            self.games = games
        }
    }
    
}
