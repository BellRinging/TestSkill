//
//  mainTabBarController.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD

class MainTabBarController: UITabBarController ,UITabBarControllerDelegate {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkIfProfitSetup()
    }
    
    func showLoginPage(){
        let loginController = LoginController()
        loginController.delegrate = self
        self.present(loginController, animated: true, completion: nil)
    }
    
    func showProfileSetupPage(name : String){
        let profile = ProfileSetupController()
        profile.userName = name
        let nav = UINavigationController(rootViewController: profile)
        self.present(nav, animated: true, completion: nil)
    }
    
 
    func checkIfProfitSetup(){
        
        print("Check if user login ")
        guard let user = Auth.auth().currentUser else {
            print("User not login")
            perform(#selector(showLoginPage), with: self, afterDelay: 0.01)
            return
        }
        print("Check if user profile setup")
        let ref = Database.database().reference().child("users")
        ref.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? [String: Any] {
                print("User Profile already setup")
                NotificationCenter.default.post(name: ProfileSetupController.updateProfile, object: nil)
                Utility.hideProgress()
            } else {
                print("User Profile not setup")
                let displayname = user.displayName ?? ""
                self.showProfileSetupPage(name: displayname)
                Utility.hideProgress()
            }
//            Utility.hideProgress()
            
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewControllers?.index(of: viewController) == 2 {
            return false
        }else{
            return true
        }
    }
    
    
    
    func setupTabBar(){
    
        let home = templateController(#imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), rootController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let search = templateController(#imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"), rootController: SearchViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let add = templateController(#imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"))
       
        let profile = templateController(#imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"), rootController: ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
    
        let bookmark = templateController(#imageLiteral(resourceName: "ribbon"), unselectedImage: #imageLiteral(resourceName: "ribbon"), rootController: BookmarkViewController(collectionViewLayout: UICollectionViewFlowLayout()))
    
        viewControllers = [profile,home,search,add,bookmark]
        tabBar.tintColor = UIColor.black
       tabBar.items?.forEach({ (item) in
            item.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
       })
    
    }
    
    
    
    func templateController(_ selectedImage : UIImage , unselectedImage : UIImage ,rootController : UIViewController = UIViewController()) -> UINavigationController{
  
        let  nav = UINavigationController(rootViewController: rootController)
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.image = unselectedImage
        
        return nav
        
    }
}
