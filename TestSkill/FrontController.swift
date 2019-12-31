//
//  FrontController.swift
//  TestSkill
//
//  Created by Kenny Yeung on 5/9/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD
import Promises

class FrontController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkIfProfitSetup()
    }
    
    @objc func showLoginPage(){
        
        let loginController = LoginController()
        loginController.delegrate = self
        loginController.modalPresentationStyle = .fullScreen
       
        self.present(loginController, animated: true, completion: nil)
    }
    
    @objc func showMainPage(){
        
            let vc = MainTabBarController()
            print("Show main page")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
                
      }
    
    func showProfileSetupPage(){
        let profile = ProfileSetupController()
        let nav = UINavigationController(rootViewController: profile)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func checkIfProfitSetup(){
   
        print("Check if user login ")
        guard let user = Auth.auth().currentUser else {
            print("User not login ,show login page")
            perform(#selector(showLoginPage), with: self, afterDelay: 0.01)
            return
        }
        Utility.firebaseUser = user
        print("Check if user profile setup")

        if let islogin = UserDefaults.standard.object(forKey: StaticValue.LOGINKEY) as? Bool ,islogin == true{
            print("profile is proper setup , show main page")
            perform(#selector(showMainPage), with: self, afterDelay: 0.01)

        }else {
            
            User.getById(id: user.uid).then { user in
                if let _ = user{
                    print("User Profile already setup")
                    UserDefaults.standard.set(true, forKey: StaticValue.LOGINKEY)
//                    NotificationCenter.default.post(name: ProfileSetupController.updateProfile, object: nil)
                    self.showMainPage()
                }else{
                    print("profile is not yet setup , show register page")
                    self.showProfileSetupPage()
                }
            }
        }
    }
    
  
    
}
