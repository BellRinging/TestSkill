//
//  AppDelegate.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import FBSDKCoreKit
import GoogleSignIn
import SwiftUI
import FirebaseAuth
import Promises

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,GIDSignInDelegate {
    
    

    var window: UIWindow?
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //Firebase
        FirebaseApp.configure()
        
        //Google API
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
         GIDSignIn.sharedInstance().delegate  = self
        //Facebook Config
        
        LoginManager.shared.facebookConfiguration(application, didFinishLaunchingWithOptions: launchOptions)
        
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
//        window?.rootViewController = GameViewController()
//        window?.rootViewController = AddSampleData()
//        window?.rootViewController = CurrentViewController(collectionViewLayout: UICollectionViewFlowLayout())
        window?.rootViewController =
//            UIHostingController(rootView:  Sample())
        FrontEndController()
//            TestAddGroup(group:PlayGroup(),players: [User()]))
//        if let user = Auth.auth().currentUser{
//            print(user.uid)
//            background.async {
//                let remp = try! await (User.getAllItem())
//                DispatchQueue.main.async {
//                    self.window?.rootViewController = UIHostingController(rootView:  ShowUser(players: remp).)
//                    print("print")
//                }
//            }
//        }
//        print("printing")
        return true
//        attemptRegisterForNotification(application: application)
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("inside callback")
        if error != nil {
            return
        }else{
            guard let authentication = user.authentication else { return }
            print("Sign success by Google , get google info")
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
            

    

    /*
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    
    func attemptRegisterForNotification(application : UIApplication){
        print("Attemp to register APNS")
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {granted, err in
                    if let err = err {
                        print("err:",err.localizedDescription)
                    }else {
                        print("granted")
                        let fcmToken = Messaging.messaging().fcmToken
                        Utility.fcmToken = fcmToken
                        print("FCM token: \(fcmToken ?? "")")
                    }
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
     
        
    }

//    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
//        print("Registered with token :",fcmToken)
//        Utility.fcmToken = fcmToken
//    }
    */
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        AppEventsLogger.activate(application)
//        AppEvents.activateApp()
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
    

    


//
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        let userInfo = response.notification.request.content.userInfo
//
//        if let followerId = userInfo["followerId"] as? String {
//            print(followerId)
//
//            // I want to push the UserProfileController for followerId somehow
//
//
//            Database.fetchUserWithUID(uid: followerId, completion: { (user) in
//                let userProfileController = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
//                userProfileController.user = user
//                if let mainTabBarController = self.window?.rootViewController as? MainTabBarController {
//
//                    mainTabBarController.selectedIndex = 0
//
//                    mainTabBarController.presentedViewController?.dismiss(animated: true, completion: nil)
//
//                    if let homeNavigationController = mainTabBarController.viewControllers?.first as? UINavigationController {
//
//                        homeNavigationController.pushViewController(userProfileController, animated: true)
//
//                    }
//
//                }
//            })
//        }
//    }
}


