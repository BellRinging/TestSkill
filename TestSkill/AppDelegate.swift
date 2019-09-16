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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        return
    }
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //Firebase
        FirebaseApp.configure()
        
        //Google API
        configGoogleAPI()
        
        //Facebook Config
        LoginManager.shared.facebookConfiguration(application, didFinishLaunchingWithOptions: launchOptions)
        
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        window?.rootViewController = FrontController()
//        window?.rootViewController = AddSampleData()
        
//        attemptRegisterForNotification(application: application)
        
        return true
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
    func configGoogleAPI(){

        GIDSignIn.sharedInstance()?.clientID = "660224651723-ipdvbl2a4atqpqfjroecchp6q09jcr5p"
        GIDSignIn.sharedInstance()?.delegate = self
        
   
    }

    
  
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        AppEventsLogger.activate(application)
        AppEvents.activateApp()
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
        
        return GIDSignIn.sharedInstance().handle(url,
                                                            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?,
                                                            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
//        guard let urlScheme = url.scheme else { return false }
//        print(urlScheme)
//        if urlScheme.starts(with: "fb"){
//            return  LoginManager.shared.facebookUrlConfiguration(app, open: url,
//                                                                 sourceApplication:
//                options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplication.OpenURLOptionsKey.annotation] ?? "")
//
//        }else {
//
//        }
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


