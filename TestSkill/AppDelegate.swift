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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,GIDSignInDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Firebase
        FirebaseApp.configure()
        
        //Google API
        configGoogleAPI()
        
        //Facebook Config
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        window?.rootViewController = MainTabBarController()
        
        return true
    }
    
    
    func configGoogleAPI(){
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self
    }
    
 
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        guard let controller = GIDSignIn.sharedInstance().uiDelegate as? SiginViewController else { return }
        if let error = error {
            Utility.showError(controller, message: error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        controller.firebaseLogin(credential)
    
        
        if (error == nil) {
            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
            
            print("User have sign in into google \(user)")
//            print(userId)
//            print(idToken)
//            print(fullName)
//            print(givenName)
//            print(familyName)
//            print(email)
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
                                          annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func showProgress(){
        guard let mainWindow = UIApplication.shared.delegate?.window else { return }
        let progressIcon = MBProgressHUD.showAdded(to: mainWindow!, animated: true)
        progressIcon.labelText = "Loading"
        progressIcon.isUserInteractionEnabled = false
        let tempView = UIView(frame: (mainWindow?.frame)!)
        tempView.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        tempView.tag = 999
        mainWindow?.addSubview(tempView)
        progressIcon.show(animated: true)
    }
    
    func hideProgress(){
        guard let mainWindow = UIApplication.shared.delegate?.window else { return }
        MBProgressHUD.hideAllHUDs(for: mainWindow!, animated: true)
        let view = mainWindow?.viewWithTag(999)
        view?.removeFromSuperview()
    }
    
    

    
}

