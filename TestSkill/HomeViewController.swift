
//  HomeViewController.swift
//  SnookerGambling
//
//  Created by Kwok Wai Yeung on 6/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.

import UIKit
import FirebaseDatabase
import FirebaseAuth
import UserNotifications

class HomeViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout , HomePostCellDelegate {
  
    let cellId = "cellId"
    var posts = [Post]()
    var tempPost = [Post]()
    
    var user : User? {
        didSet{
        }
    }
    
    var homeCell : HomeViewControllerCell?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: ProfileSetupController.updateProfile, object: nil)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomeViewControllerCell.self, forCellWithReuseIdentifier: cellId)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        collectionView?.delegate = self
        setupBarButtom()
        fetchPost()
    }
    
    func handleUpdateFeed() {
        handleRefresh()
    }
    
    
    func handleRefresh(){
        posts.removeAll()
        collectionView?.reloadData()
        fetchPost()
    }
    
    func didTapOption(for cell: HomeViewControllerCell){
        let alert = UIAlertController(title: nil, message: "Select action", preferredStyle: UIAlertControllerStyle.actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.default){
            (action) -> Void in
            guard let indexPath = self.collectionView?.indexPath(for: cell) else { return }
            let shareView = SharePhotoController()
            shareView.editFlag = 1
            shareView.post = cell.post
            let nav = UINavigationController(rootViewController: shareView)
            self.present(nav, animated: true, completion: nil)
        }
        alert.addAction(editAction)
        let alertAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive)
        {
            (action) -> Void in
            
            let alert2 = UIAlertController(title: nil, message: "Confirm to delete?", preferredStyle: UIAlertControllerStyle.alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive){
                action -> Void in
                guard let indexPath = self.collectionView?.indexPath(for: cell) else { return }
                self.deleteUserPost(index: indexPath.item)
            }
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default){
                (action) -> Void in
                print("Cancel")
            }
            alert2.addAction(yesAction)
            alert2.addAction(noAction)
            self.present(alert2, animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            (action) -> Void in
            print("Cancel")
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didLike(for cell: HomeViewControllerCell){
        
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [uid: post.hasliked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
            
            if let err = err {
                print("Failed to like post:", err)
                return
            }
            
            post.hasliked = !post.hasliked
            print("Successfully liked post.")
//            self.posts[indexPath.item] = post
            guard let count = post.likeCount else {return }
            if post.hasliked == true {
                post.likeCount = count + 1
            }else{
                post.likeCount = count - 1
            }
            self.collectionView?.reloadItems(at: [indexPath])
            
        }
    }
    
    
    
    func setupBarButtom(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCarema))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCarema))
        navigationItem.titleView =  UIImageView(image: #imageLiteral(resourceName: "logo2").withRenderingMode(.alwaysOriginal))
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func handleCarema(){
        print("Carema")
        let vc = CameraController()
        self.present(vc, animated: true, completion: nil)
        
    }
    

    func didShare(for cell: HomeViewControllerCell) {
        print("Share")
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print(post.caption)
        post.caption.share()
        
    }
    
    func didTagImage(for cell: HomeViewControllerCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        let vc = DisplayPhotoView()
        vc.imageUrl = posts[indexPath.row].imageUrl
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeViewControllerCell
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    
    func fetchUserPost(_ group:DispatchGroup , uid: String){
        print("fretch user post :\(uid)")
        group.enter()
        Database.fetchUserWithUID(uid: uid) { (user) in
            let ref = Database.database().reference().child("posts").child(uid)
            ref.observeSingleEvent(of: .value, with: { (snapsnot) in
                guard let dictionary = snapsnot.value as? [String: Any] else { return }
                print("No of post for user:" , dictionary.count ," For user", user.name)
                dictionary.forEach({ (key,value) in
                    let dict = value as! [String:Any]
                    var post = Post(user: user, dict: dict)
                    post.id = key
                    guard let currentId = Auth.auth().currentUser?.uid else {return }
                    self.tempPost.append(post)
                    print(post)
                })
//                print("Group leave for user",user.name)
                group.leave()
            })
        }
    }
    
    
    func deleteUserPost(index : Int){
        guard let postId = self.posts[index].id else {return}
        let userId = self.posts[index].user.id
        let ref = Database.database().reference().child("posts").child(userId).child(postId)
        print("post",postId)
        print("user",userId)
        ref.removeValue()
        posts.remove(at: index)
        collectionView?.reloadData()
    }
    
    func didTapComment(post: Post) {
        let commentsController = CommentViewController()
        commentsController.post = post
//        let commentsController = UIViewController()
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func fetchPost(){
        print("Refresh")
        collectionView?.refreshControl?.endRefreshing()
        tempPost = [Post]()
        guard let uid = Auth.auth().currentUser?.uid else {return }
        let myGroup = DispatchGroup()
        fetchUserPost(myGroup , uid: uid)
        print("Start fetch from following people..")
        let ref = Database.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            print("User has followed \(userIdsDictionary.count) user")
            userIdsDictionary.forEach({ (key, value) in
                self.fetchUserPost(myGroup,uid:key)
            })
        })
        myGroup.notify(queue: DispatchQueue.main, execute: {
//            print("Wait all to finish")
            self.tempPost.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.posts = self.tempPost
            self.collectionView?.reloadData()
        })
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let post = self.posts[indexPath.row]
            var height = 8 + 40 + 8 + UIScreen.main.bounds.width + 8 + 40 + 8
        let cell = HomeViewControllerCell()
            height = height + cell.calculatTextHeigh(post: post)
//            print(cell.calculatTextHeigh(post: post))
            return CGSize(width: UIScreen.main.bounds.width, height: height)
        
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("End of scrolling")
        guard let origin = collectionView?.contentOffset else {return}
        guard let size = collectionView?.bounds.size else {return}
        
        let visibleRect = CGRect(origin: origin, size: size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = collectionView?.indexPathForItem(at: visiblePoint)
        print("indexPath : " , indexPath?.item)
        
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("End of scrollViewDidEndDecelerating")
        guard let origin = collectionView?.contentOffset else {return}
        guard let size = collectionView?.bounds.size else {return}
        
        let visibleRect = CGRect(origin: origin, size: size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = collectionView?.indexPathForItem(at: visiblePoint)
        print("indexPath : " , indexPath?.item)
        
        print(" visibleRect : " , visibleRect)
        print("visiblePoint  : " , visiblePoint)
        print("visible cell : " , collectionView?.visibleCells)
    }
}


