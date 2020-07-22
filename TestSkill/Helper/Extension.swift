//
//  Extendsion.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let updateGame = Notification.Name("updateGame")
    static let updateUserBalance = Notification.Name("updateUserBalance")
    static let updateLastGameRecord = Notification.Name("updateLastGameRecord")
    static let updateLastBig2GameRecord = Notification.Name("updateLastBig2GameRecord")
    static let addPlayGroup = Notification.Name("addPlayGroup")
    static let addFriend = Notification.Name("addFriend")
    static let deleteFriend = Notification.Name("deleteFriend")
    static let updateUser = Notification.Name("updateUser")
    static let test = Notification.Name("test")
    static let dismissAddGameView = Notification.Name("dismissAddGameView")
    static let dismissMainView = Notification.Name("dismissMainView")
    static let dismissSwiftUI = Notification.Name("dismissSwiftUI")
    static let loginCompleted = Notification.Name("loginCompleted")
    static let dismissPlayGroup = Notification.Name("dismissPlayGroup")
    static let FCMToken = Notification.Name("FCMToken")
    static let flownGame = Notification.Name("flownGame")
    static let deleteGame = Notification.Name("deleteGame")
    static let loadMoreGame = Notification.Name("loadMoreGame")
    static let finishLoadGame = Notification.Name("finishLoadGame")
}


extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame {
                let statusBarView = UIView(frame: statusBarFrame)
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            } else if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            } else {
                return nil
            }
        }else{
            return nil
        }
    }
}


struct UserDefaultsKey  {
    static let CurrentUser = "CurrentUser"
    static let  CurrentGroup = "CurrentGroup"
    static let  CurrentGroupUser = "CurrentGroupUser"
    static let  LoginFlag = "LoginFlag"
    static let  FcmToken = "FcmToken"
    static let  AppleIdUser = "AppleIdUser"
    static let  ActAsUser = "ActAsUser"
    
}

extension UserDefaults {
   func save<T:Encodable>(customObject object: T, inKey key: String) {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(object) {
           self.set(encoded, forKey: key)
       }
   }

   func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
       if let data = self.data(forKey: key) {
           let decoder = JSONDecoder()
           if let object = try? decoder.decode(type, from: data) {
               return object
           }else {
               print("Couldnt decode object for key : \(key)")
               return nil
           }
       }else {
           return nil
       }
   }
}


extension Int: Identifiable {
  public var id: Int {
    return self
  }
}

extension String: Identifiable {
  public var id: String {
    return self
  }
}
