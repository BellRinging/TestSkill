//
//  SceneDelegate.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 31/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import SwiftUI
//
//  SceneDelegate.swift
//
import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        let newAppearance = UINavigationBarAppearance()
        newAppearance.shadowColor = .clear
        newAppearance.configureWithOpaqueBackground()
        newAppearance.backgroundColor = UIColor.rgb(red: 225, green: 0, blue: 0)
        newAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = newAppearance
        UINavigationBar.appearance().tintColor =  UIColor.white
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            window?.rootViewController = FrontEndController()
//             UIApplication.shared.statusBarUIView?.backgroundColor = UIColor.rgb(red: 225, green: 0, blue: 0)
            self.window!.makeKeyAndVisible()
        }
      
    }
}
