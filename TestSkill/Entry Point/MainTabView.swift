//
//  TestMainTabView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 3/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct MainTabView: View {
        

    @ObservedObject var viewModel: MainTabViewModel
    
    
    init() {
        viewModel = MainTabViewModel()
    }
    

    
    var body: some View {
        
        if self.viewModel.status == .loading {
            return AnyView(Text("Loading..."))
        }else{
            return AnyView(TabbarView(showAdmin: self.viewModel.userId == self.viewModel.uid).accentColor(Color.redColor))
        }
        
    }
}


struct TabbarView: View {
    @State var selectedTab = Tab.game
    var showAdmin : Bool
    
    enum Tab: Int {
        case game, search, menu,edit,admin
    }
    
    func tabbarItem(text: String, image: String ) -> some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            if showAdmin == true {
                LazyView(AdminView())
                    .tabItem{
                        self.tabbarItem(text: "Admin", image: "magnifyingglass.circle.fill")
                }.tag(Tab.admin)
            }
            
            LazyView(SearchView())
                .tabItem{
                    self.tabbarItem(text: "Search", image: "magnifyingglass.circle.fill")
            }
            .tag(Tab.search)
            
            LazyView(GameView())
                .tabItem{
                    self.tabbarItem(text: "Game", image: "book.fill")
            }.tag(Tab.game)
            
            LazyView(MenuPage().equatable())
                .tabItem{
                    self.tabbarItem(text: "Menu", image: "list.bullet")
            }.tag(Tab.menu)
        }
    }
}
