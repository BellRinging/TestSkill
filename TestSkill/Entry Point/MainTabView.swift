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
        
    @State private var selectedView = 2
    
    init() {
     saveCurrentUser()
    }
    
    func saveCurrentUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        User.getById(id: uid).then { (user)  in
            if let userFromDefault = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser) {
                if (userFromDefault != user){
                    print("Update Current user")
                    UserDefaults.standard.save(customObject: userFromDefault, inKey: UserDefaultsKey.CurrentUser)
                }
            }else {
                UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
            }
        }
    }
    
    var body: some View {
        
    
        TabView(selection: $selectedView, content: {
            TestFont()
                .tabItem {
                    selectedView == 0 ? Image(systemName: "book.fill"):Image(systemName: "book")
                    Text("History")
            }.tag(0)
            TestFont()
                .tabItem {
                    selectedView == 1 ? Image(systemName: "magnifyingglass.circle.fill"):Image(systemName: "magnifyingglass.circle")
                    Text("Search")
            }.tag(1)
//
            LazyView(GameView())
                .tabItem {
                    selectedView == 2 ? Image(systemName: "person.fill"):Image(systemName:"person")
                    Text("Home")
            }.tag(2)
//
            TestFont()
                .tabItem {
                    selectedView == 3 ? Image(systemName: "tv.fill"):Image(systemName: "tv")
                    Text("Admin")
            }.tag(3)
            TestMenuPage()
                .tabItem {
                    selectedView == 4 ? Image(systemName: "list.bullet"):Image(systemName: "list.bullet.indent")
                    Text("Menu")
            }.tag(4)
            })
            .accentColor(Color.redColor)
    }
}

struct TestMainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
