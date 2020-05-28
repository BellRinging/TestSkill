//
//  ChatDetailViewModel.swift
//  QBChat-MVVM
//
//  Created by Paul Kraft on 30.10.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import SwiftUI

enum Linkage: String {
    case UpdateBalance
    case MyAccount
    case PlayGroup
    case Friend
    case Language
    case ContactUs
    case logout
}

struct ItemObj : Identifiable{
    let id  = UUID()
    let icon : String
    let caption : String
    let action : Linkage
}


class MenuPageViewModel: ObservableObject {
    
    @Published var isShowUpdateBalance : Bool = false
    @Published var isShowPlayGroup : Bool = false
    @Published var isShowFriend : Bool = false
    @Published var isShowTerm : Bool = false
    @Published var isShowContactUs : Bool = false
    @Published var isShowAccount : Bool = false{
        didSet{
            if isShowAccount == false{
                refreshUser()
            }
        }
    }
    @Published var tempUser : [User] = []
    var user : User
    
    init(){
        user = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
    }
    
    func refreshUser(){
        user = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.CurrentUser)!
    }

   var items = [
    ItemObj(icon: "dollarsign.circle.fill", caption: "Correct your Balance", action: Linkage.UpdateBalance),
    ItemObj(icon: "person.fill", caption: "My Account", action: Linkage.MyAccount),
    ItemObj(icon: "person.2.fill", caption: "Play Group", action: Linkage.PlayGroup),
    ItemObj(icon: "person.3.fill", caption: "Friend", action: Linkage.Friend),
    ItemObj(icon: "textformat.abc", caption: "Language", action: Linkage.Language),
    ItemObj(icon: "bubble.left.and.bubble.right.fill", caption: "Contact Us", action: Linkage.ContactUs),
    ItemObj(icon: "arrow.right.square", caption: "Logout", action: Linkage.logout)
   ]
    
    func performAction(action : Linkage){
            switch (action) {
            case .UpdateBalance:
                withAnimation {
                    isShowUpdateBalance = true
                }
                return
            case .MyAccount:
                withAnimation {
                    isShowAccount = true
                }
                return
            case .PlayGroup:
                withAnimation {
                    isShowPlayGroup = true
                }
                return
            case .Language:
                Utility.showAlert(message: "No available this moment")
                return
            case .Friend:
                withAnimation {
                    isShowFriend = true
                }
                return
            case .ContactUs:
                withAnimation {
                    isShowContactUs = true
                }
                return
            case .logout:
                logout()
                return
            default:
                return
            }
    }

    func logout(){
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.CurrentUser)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.CurrentGroup)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.CurrentGroupUser)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LoginFlag)
        NotificationCenter.default.post(name: .dismissMainView ,object: nil)
        print("Completed logout")
    }
}
