//
//  AppDelegate.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import MBProgressHUD
import UserNotifications
import GoogleSignIn
import FBSDKCoreKit
import FirebaseMessaging
import FirebaseDatabase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,GIDSignInDelegate  ,UNUserNotificationCenterDelegate , MessagingDelegate{
 

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //Firebase
                FirebaseApp.configure()
                let db = Firestore.firestore()
                
                //Google API
                configGoogleAPI()
            
                //Facebook Config
                ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
                
                window?.frame = UIScreen.main.bounds
                window?.makeKeyAndVisible()
                window?.rootViewController = MainTabBarController()
                
                attemptRegisterForNotification(application: application)
                
                return true
    }
    
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

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Registered with token :",fcmToken)
        Utility.fcmToken = fcmToken
    }
    
    func configGoogleAPI(){
        var configureError: NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance()?.clientID = "660224651723-ipdvbl2a4atqpqfjroecchp6q09jcr5p"
        GIDSignIn.sharedInstance().delegate = self
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        Utility.showProgress()
        guard let controller = GIDSignIn.sharedInstance().uiDelegate as? SiginViewController else { return }
        if let error = error {
            Utility.showError(controller, message: error.localizedDescription)
            Utility.hideProgress()
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
    
        
        if (error == nil) {
            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            let dimension = round(100 * UIScreen.main.scale)
            let pic = user.profile.imageURL(withDimension: UInt(dimension)).absoluteString
            print("User have sign in into google \(user)")
            let dict = ["first_name": givenName,"last_name": familyName, "email":email  ,"name": givenName ,"img_url":pic] as [String : Any]
            let user = User(dict: dict)
            Utility.user = user
            controller.firebaseLogin(credential,provider: "Google")
        } else {
            print("\(error.localizedDescription)")
            Utility.hideProgress()
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        print("disconnect from google")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        AppEventsLogger.activate(application)
        AppEvents.activateApp()
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        guard let urlScheme = url.scheme else { return false }
        if urlScheme.hasPrefix("fb") {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }else{
            return GIDSignIn.sharedInstance().handle(url,
                                                      sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?,
                                                      annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
        return true
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let followerId = userInfo["followerId"] as? String {
            print(followerId)
            
            // I want to push the UserProfileController for followerId somehow
            
           
            Database.fetchUserWithUID(uid: followerId, completion: { (user) in
                let userProfileController = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
                userProfileController.user = user
                if let mainTabBarController = self.window?.rootViewController as? MainTabBarController {
                    
                    mainTabBarController.selectedIndex = 0
                    
                    mainTabBarController.presentedViewController?.dismiss(animated: true, completion: nil)
                    
                    if let homeNavigationController = mainTabBarController.viewControllers?.first as? UINavigationController {
                        
                        homeNavigationController.pushViewController(userProfileController, animated: true)
                        
                    }
                    
                }
            })
        }
    }
}


