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
        
//    @State private var selectedView = 0
    var uid = "8QfQrvQEklaD9tKfksXrbmOaYo53"
    var userId = ""
    
    
    init() {
     saveCurrentUser()
//        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor.rgb(red: 225, green: 0, blue: 0)
    }
    
    mutating func saveCurrentUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.userId = uid
        User.getById(id: uid).then { (user)  in
            if let user = user {
                UserDefaults.standard.save(customObject: user, inKey: UserDefaultsKey.CurrentUser)
                if let token = UserDefaults.standard.retrieve(object: String.self, fromKey: UserDefaultsKey.FcmToken){
                    if user.fcmToken != token {
                        user.updateFcmToken(token: token).catch { (err) in
                            Utility.showAlert(message: err.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        TabbarView(showAdmin: userId == uid).accentColor(Color.redColor)
    }
}


struct TabbarView: View {
    @State var selectedTab = Tab.game
    var showAdmin : Bool

    
    enum Tab: Int {
        case game, search, menu,edit,admin
    }
    
    func tabbarItem(text: String, image: String ,selectedImage: String) -> some View {
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
                        self.tabbarItem(text: "Admin", image: "magnifyingglass.circle.fill", selectedImage: "magnifyingglass.circle")
                }.tag(Tab.admin)
            }
           LazyView(SearchView())
                 .tabItem{
                     self.tabbarItem(text: "Search", image: "magnifyingglass.circle.fill", selectedImage: "magnifyingglass.circle")
                 }.tag(Tab.search)
            LazyView(GameView())
                .tabItem{
                    self.tabbarItem(text: "Game", image: "book.fill",selectedImage: "book")
            }.tag(Tab.game)
            
      
            LazyView(MenuPage())
                .tabItem{
                    self.tabbarItem(text: "Menu", image: "list.bullet", selectedImage: "list.bullet.indent")
            }.tag(Tab.menu)
            
        }
//        .statusBar(hidden: false)
//        .edgesIgnoringSafeArea(.top)
    }
}
