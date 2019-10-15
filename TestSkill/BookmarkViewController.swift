//
//  HomeViewController.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class BookmarkViewController: UICollectionViewController {
    
    
    weak var delegrate : MainTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         collectionView?.backgroundColor = UIColor.brown
        let barButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func handleLogout(){
//        guard let user = Utility.firebaseUser ,let providerID = user.providerData.first?.providerID  else {return }

        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.set(false, forKey: StaticValue.LOGINKEY)
        UserDefaults.standard.removeObject(forKey: StaticValue.PROVIDERUSER)
        delegrate?.dismiss(animated: true, completion: nil)
        print("Logout")
        
    }
    
}
