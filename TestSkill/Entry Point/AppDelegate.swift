//
//  AppDelegate.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import SwiftUI
import FirebaseAuth
import Promises
import UserNotifications
import UserNotificationsUI
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate ,MessagingDelegate,GIDSignInDelegate{
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //Firebase
        FirebaseApp.configure()
        
        //Message & notification
        attemptRegisterForNotification(application:application)
        //Google API
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate  = GoogleDelegates()
        GIDSignIn.sharedInstance().delegate  = self
        //Facebook Config
        LoginManager.shared.facebookConfiguration(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func attemptRegisterForNotification(application : UIApplication){
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (geant, err) in}
        application.registerForRemoteNotifications()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
          if error != nil {
              return
          }else{
              guard let authentication = user.authentication else { return }
              print("Signed In by Google")
              var tempUser = ProviderUser()
              tempUser.userName = user.profile.name
              tempUser.firstName = user.profile.givenName
              tempUser.lastName = user.profile.familyName
              tempUser.email = user.profile.email
              tempUser.imgUrl = user.profile.imageURL(withDimension: 100)?.absoluteString
              let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                             accessToken: authentication.accessToken)
              let tokenDict:[String: Any] = ["token": credential , "user": tempUser ]
              NotificationCenter.default.post(name: .loginCompleted, object: nil,userInfo: tokenDict)
        
          }
      }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let urlScheme = url.scheme else { return false }
        print("Schema : \(urlScheme)")
        var facebookOrGoogle : Bool = false
        if urlScheme.starts(with: "fb"){
            facebookOrGoogle = LoginManager.shared.facebookUrlConfiguration(app, open: url,
                                                                 sourceApplication:
                options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplication.OpenURLOptionsKey.annotation] ?? "")
        }else {
            print("handle for google \(url)")
            facebookOrGoogle = (GIDSignIn.sharedInstance()?.handle(url))!
        }
        return facebookOrGoogle
    
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        if let token = UserDefaults.standard.retrieve(object: String.self, fromKey: UserDefaultsKey.FcmToken) {
            if token != fcmToken {
                print("Token Change : \(fcmToken)")
                UserDefaults.standard.save(customObject: fcmToken , inKey: UserDefaultsKey.FcmToken)
            }
        }else{
            print("Add token : \(fcmToken)")
            UserDefaults.standard.save(customObject: fcmToken, inKey: UserDefaultsKey.FcmToken)
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Push notification received in backgroup.")
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        print(userInfo["userId"])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Push notification received in foreground.")
        print(notification.request.content.userInfo["userId"])
        
        
        completionHandler([.alert, .sound, .badge])
    }
}


extension UIApplication {
    var window: UIWindow? {
        connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    }
}
