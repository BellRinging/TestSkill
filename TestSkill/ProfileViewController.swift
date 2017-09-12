//
//  HomeViewController.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    
    let headerID = "headerID"
    let cellID = "cellID"
    let post = [Post]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView?.register(SinglePhotoCell.self, forCellWithReuseIdentifier: cellID)
        
        let barButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = barButton
        
        self.navigationItem.leftBarButtonItem = barButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileChange), name: ProfileSetupController.updateProfile, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View Will appear")
    }
    
    func handleProfileChange(){
        print("From Profile Setup Page")
        collectionView?.reloadData()
    }
    
    
    func handleLogout(){
        if let user = Auth.auth().currentUser?.uid {
            print(user)
            do {
                try Auth.auth().signOut()
            }catch {
            
            }
        }
        let tabBar = tabBarController as? MainTabBarController
        tabBar?.checkIfProfitSetup()
        print("Logout")
        
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-3)/4
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SinglePhotoCell
        cell.backgroundColor = UIColor.green
        
        return cell
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("Config the header cell")
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath)  as! ProfileHeaderCell
        if let user = Auth.auth().currentUser{
            let dict = ["id": user.uid , "email":user.email , "user_name": user.displayName]
            let userObject = User(dict: dict)
            cell.user = userObject
        }
        
         cell.backgroundColor = UIColor.white
            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let height = 80 + 8 + 8 + 30 + 1 + 20 + 8
        return CGSize(width: view.frame.width, height: CGFloat(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
}
