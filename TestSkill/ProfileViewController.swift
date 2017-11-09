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
    var headerCell : ProfileHeaderCell?
    var isUpdating = false
    var isScrolling = false
    var totalNumberOfPost = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView?.register(SinglePhotoCell.self, forCellWithReuseIdentifier: cellID)
        
        let barButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = barButton
        
        self.navigationItem.leftBarButtonItem = barButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileChange), name: ProfileSetupController.updateProfile, object: nil)
        handleProfileChange()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadMore), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
    }
    
    func fetchPost(){
        guard let user = self.user else { return }
        print("fetchPost from user \(user.id)")
        self.posts = [Post]()
        let ref = Database.database().reference().child("posts").child(user.id)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                 if let dict = snapshot.value as? [String:Any] {
                    self.totalNumberOfPost = dict.count
                    print("Total post count : \(self.totalNumberOfPost)")
                    self.loadMore()
                }
        })
    }
    
    func loadMore(){
        guard let user = self.user else {return }
        let initialDataFeed = posts.count
        let ref = Database.database().reference().child("posts").child(user.id)
        var endPosition = Int()
        if (totalNumberOfPost - initialDataFeed - 24  > 0 ){
            endPosition = totalNumberOfPost - initialDataFeed
        }else {
            endPosition = totalNumberOfPost
        }
         print("start position :\(totalNumberOfPost - initialDataFeed - 24 ) end position :\(endPosition)" )
        ref.queryOrderedByKey().queryStarting(atValue: String(totalNumberOfPost - initialDataFeed - 24)).queryEnding(atValue: String(endPosition))
            .observe(.value, with: { (snapshot) in
                print("snapshot :\(snapshot.exists())" )
                if let dict = snapshot.value as? [String:Any] {
                    print("fetch reasult count :\(dict.count)" )
                    dict.forEach({ (key,value) in
                        guard let postDict = value as? [String: Any] else {return}
                        let post = Post(user: user , dict: postDict as [String : AnyObject])
                        self.posts.insert(post, at: 24 * Int(self.posts.count/24))
                        self.posts.sorted(by: { $0.creationDate > $1.creationDate })
                        print("Post added : \(post.imageUrl)")
                    })
                    self.collectionView?.reloadData()
                    self.isUpdating = false
                }
                self.collectionView?.refreshControl?.endRefreshing()
                print("finish fetch")
            })
    
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("scrolling")
        isScrolling = true
    }
    

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("finish scrolling")
        isScrolling = false
    }
    
    func handleProfileChange(){
        print("handle profile change \(isUpdating)")
        if (isScrolling || isUpdating){
            print("No refresh when scrolling")
            return
        }
        isUpdating = true
        guard let uid = Auth.auth().currentUser?.uid else { return}
        if let userObj = self.user , uid != userObj.id ,userObj.id != "" {
            Database.fetchUserWithUID(uid: userObj.id , completion: { userObject in
                self.fetchPost()
            })
        }else {
            Database.fetchUserWithUID(uid: uid, completion: { userObject in
                self.user = userObject
                Utility.user = userObject
                self.fetchPost()
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
        self.posts = [Post]()
        headerCell?.profileImage.image = #imageLiteral(resourceName: "empty-avatar")
        collectionView?.reloadData()
        UserDefaults.standard.set(false, forKey: StaticValue.LOGINKEY)
        print("Logout")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("didselect item \(indexPath.item) available item \(posts.count) int item \(indexPath.row)")
        let vc = DisplayPhotoView()
        let post = posts[indexPath.item] as Post
        vc.imageUrl = post.imageUrl
        self.present(vc, animated: true, completion: nil)
//        print("4")
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
//        print("Available : \(posts.count) index : \(indexPath.item) int : \(indexPath.row)")
        cell.post = posts[indexPath.item]
        
        return cell
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        print("Config the header cell")
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath)  as! ProfileHeaderCell
        headerCell = cell
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
