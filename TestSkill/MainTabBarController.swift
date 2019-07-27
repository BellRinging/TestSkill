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
        self.delegate = self
        //Save to the static for common use
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkIfProfitSetup()
    }
    
    @objc func showLoginPage(){
        let loginController = LoginController()
        loginController.delegrate = self
        self.present(loginController, animated: true, completion: nil)
    }
    
    func showProfileSetupPage(){
        let profile = ProfileSetupController()
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
        Utility.firebaseUser = user
        print("Check if user profile setup")

        if let islogin = UserDefaults.standard.object(forKey: StaticValue.LOGINKEY) as? Bool ,islogin == true{
            print("profile is proper setup")
        }else {
            
            let ref = Database.database().reference().child("users")
            ref.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? [String: Any] {
                    print("User Profile already setup")
                    UserDefaults.standard.set(true, forKey: StaticValue.LOGINKEY)
                    NotificationCenter.default.post(name: ProfileSetupController.updateProfile, object: nil)
                    Utility.hideProgress()
                } else {
                    print("User Profile not setup")
                    self.showProfileSetupPage()
                    Utility.hideProgress()
                }
            }) { (err) in
                Utility.hideProgress()
                print("Failed to fetch user for posts:", err)
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewControllers?.index(of: viewController) == 2 {
            let vc = AddPhotoController(collectionViewLayout: UICollectionViewFlowLayout())
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
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
    
        viewControllers = [home,search,add,profile,bookmark]
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
