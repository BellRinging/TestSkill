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
import Promises

class MainTabBarController: UITabBarController ,UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        self.delegate = self
        //Save to the static for common use
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewControllers?.index(of: viewController) == 2 {
//            let vc = AddPhotoController(collectionViewLayout: UICollectionViewFlowLayout())
//            let nav = UINavigationController(rootViewController: vc)
//            self.present(nav, animated: true, completion: nil)
//            return false
//        }else{
//            return true
//        }
        return true
    }
    
    func setupTabBar(){
        let vc = BookmarkViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.delegrate = self
        let page1 = templateController(#imageLiteral(resourceName: "ribbon"), unselectedImage: #imageLiteral(resourceName: "ribbon"), rootController: vc)
        
        let vc2 = BookmarkViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.delegrate = self
        let page2 = templateController(#imageLiteral(resourceName: "ribbon"), unselectedImage: #imageLiteral(resourceName: "ribbon"), rootController: vc2)
        
        let vc3 = BookmarkViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.delegrate = self
        let page3 = templateController(#imageLiteral(resourceName: "ribbon"), unselectedImage: #imageLiteral(resourceName: "ribbon"), rootController: vc3)
//
        viewControllers = [page1,page2,page3]
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
