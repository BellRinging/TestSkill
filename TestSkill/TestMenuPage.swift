//
//  TestMenuPage.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct TestMenuPage: View {
    
    @State var items = [
        ItemObj(icon: "person.fill", caption: "My Account", linkage: "abc"),
        ItemObj(icon: "bubble.left.and.bubble.right.fill", caption: "Contact Us", linkage: "abc")
    ]
    
    init() {
//      UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().backgroundColor = UIColor.rgb(red: 225, green: 0, blue: 0)
        }
    
    
    var body: some View {
        
  
        NavigationView{
            VStack{
              
             List(items) { item in
                  NavigationLink(destination: TestFont()) {
                    self.itemTemplate(icon: item.icon, text: item.caption)
                      }
                  }
 
                HStack(alignment:.center){
                    Text("Term of use")
                    Spacer()
                    Image(systemName: "chevron.right")
                }.padding()
                HStack(alignment:.center){
                    Text("App version")
                    Spacer()
                    Text("v1.0.1")
                }.padding()
                Spacer()
            }
            .navigationBarTitle("Menu", displayMode: .inline)
            .background(NavigationConfigurator { nc in
                               nc.navigationBar.barTintColor = UIColor.rgb(red: 225, green: 0, blue: 0)
                               nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                           })
        }

    }
    
    func itemTemplate(icon:String, text:String) -> some View{
        HStack(alignment:.center){
            Image(systemName: icon)
                .resizable()
                .frame(width: 25, height: 25)
                .scaledToFit()
            Text(text)
            
        }.padding()
    }
}

struct ItemObj : Identifiable{
    let id  = UUID()
    let icon : String
    let caption : String
    let linkage : String
}

struct TestMenuPage_Previews: PreviewProvider {
    static var previews: some View {
        TestMenuPage()
    }
}
