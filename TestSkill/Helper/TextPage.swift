//
//  ListPagination.swift
//  ListPaginationSwiftUI2
//
//  Created by projas on 5/29/20.
//  Copyright © 2020 Pedro Rojas. All rights reserved.
//

import SwiftUI

public struct TextPage<Content:View>: View  {
  
//    private var games:  [String:[Game]]
    
    var games:  [String:[Game]]
    var headerContent: (String) -> Content
    var content: (Int) -> Content
    var sectionHeader : [String] = []
    
    init (games:  [String:[Game]], @ViewBuilder headerContent: @escaping (String) -> Content, @ViewBuilder content: @escaping (Int) -> Content) {
        self.games = games
        self.headerContent = headerContent
        self.content = content
        self.sectionHeader = games.keys.map{$0}
    }
    
    public var body: some View {
        
        List {
            ForEach(sectionHeader, id: \.self) { period in
                VStack{
                    self.headerContent(period)
                    self.content(1)
                }
//                Section(header: self.headerContent(period)) {
//                    ForEach(self.games[period]!.indices ) { index in
//                        self.content()
//                    }
//                }
            }
        }
        
        
    }
    
    
}


