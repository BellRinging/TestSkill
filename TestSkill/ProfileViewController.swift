//
//  HomeViewController.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import Firebase

class ProfileViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    
    let headerID = "headerID"
    let cellID = "cellID"
    var posts = [Post]()
    var user : User?
    
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
     
//        print("View Will appear")
    }
    
    func fetchPost(user: User){
        print("fetchPost \(user.id)")
        let ref = Database.database().reference().child("posts").child(user.id)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            guard let dict = snapshot.value as? [String:Any] else {return }
            print(dict.count)
            dict.forEach({ (key,value) in
               
                guard let postDict = value as? [String: Any] else {return}
                let post = Post(user: user , dict: postDict as [String : AnyObject])
                self.posts.append(post)
                
            })
            self.collectionView?.reloadData()
        })
    }
    
    func handleProfileChange(){
        print("handle profile change \(Utility.user)")

        if let uid = Auth.auth().currentUser?.uid{
            Database.fetchUserWithUID(uid: uid, completion: { userObject in
                self.user = userObject
                Utility.user = userObject
//                self.collectionView?.reloadData()
                self.fetchPost(user: userObject)
            })
        }
        
    
     
    }
    
    
    func handleLogout(){
        guard let user = Utility.firebaseUser ,let providerID = user.providerData.first?.providerID  else {return }
        
        if (providerID == FacebookAuthProviderID ){
            let loginManager = LoginManager()
            loginManager.logOut()
        }else if (providerID == GoogleAuthProviderID){
            
        }
        
        do {
            try Auth.auth().signOut()
        }catch {
        
        }
        let tabBar = tabBarController as? MainTabBarController
        tabBar?.checkIfProfitSetup()
        Utility.user = nil
        Utility.firebaseUser = nil
        print("Logout")
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-3)/4
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SinglePhotoCell
//        cell.backgroundColor = UIColor.green
        cell.post = posts[indexPath.item]
        
        return cell
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("Config the header cell")
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath)  as! ProfileHeaderCell
         cell.backgroundColor = UIColor.white
        cell.user = self.user
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
