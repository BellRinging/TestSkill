
//  HomeViewController.swift
//  SnookerGambling
//
//  Created by Kwok Wai Yeung on 6/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout , HomePostCellDelegate {
    //    let headerId = "headerId"
    //    let footerId = "footerId"
    let cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SearchViewController.updateFeedNotificationName, object: nil)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomeViewControllerCell.self, forCellWithReuseIdentifier: cellId)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
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
    
    func didLike(for cell: HomeViewControllerCell){
        
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [uid: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
            
            if let err = err {
                print("Failed to like post:", err)
                return
            }
            
            print("Successfully liked post.")
            
            post.hasLiked = !post.hasLiked
            
            self.posts[indexPath.item] = post
            guard let count = post.likeCount else {return }
            if post.hasLiked == true {
                post.likeCount = count + 1
            }else{
                post.likeCount = count - 1
            }
            self.collectionView?.reloadItems(at: [indexPath])
            
        }
        
        
    }
    
    
    
    func setupBarButtom(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCarema))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleShare))
        navigationItem.titleView =  UIImageView(image: #imageLiteral(resourceName: "logo2").withRenderingMode(.alwaysOriginal))
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func handleCarema(){
        print("Carema")
    }
    
    func handleShare(){
        print("Share")
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeViewControllerCell
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DisplayPhotoView()
        vc.imageUrl = posts[indexPath.row].imageUrl
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    
    func fetchUserPost(uid: String){
        Database.fetchUserWithUID(uid: uid) { (user) in
            let ref = Database.database().reference().child("posts").child(uid)
            ref.observe(.childAdded, with: { (snapsnot) in
                guard let dictionary = snapsnot.value as? [String: Any] else { return }
                var post = Post(user: user, dict: dictionary)
                post.id = snapsnot.key
                guard let currentId = Auth.auth().currentUser?.uid else {return }
                Database.database().reference().child("likes").child(snapsnot.key).child(currentId).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.refreshControl?.endRefreshing()
                    self.collectionView?.reloadData()
                })
            })
        }
        
    }
    
    func didTapComment(post: Post) {
        //        print(post.caption)
        let commentsController = CommentViewController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func fetchPost(){
        collectionView?.refreshControl?.endRefreshing()
        guard let uid = Auth.auth().currentUser?.uid else {return }
        //        let queue = DispatchQueue.global()
        //        queue.sync {
        fetchUserPost(uid: uid)
        //        }
        //        print("end fetch")
        print("end fetch")
        
        
        
        let ref = Database.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            userIdsDictionary.forEach({ (key, value) in
                self.fetchUserPost(uid:key)
                
            })
        })
        
        //        fetchUserPost(uid: uid)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
        height += view.frame.width
        height += 50
        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
    
    
}


