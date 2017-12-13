
//  HomeViewController.swift
//  SnookerGambling
//
//  Created by Kwok Wai Yeung on 6/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout , HomePostCellDelegate {
  
    //    let headerId = "headerId"
    //    let footerId = "footerId"
    let cellId = "cellId"
    var posts = [Post]()
    var tempPost = [Post]()
    
    var user : User? {
        didSet{
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SearchViewController.updateFeedNotificationName, object: nil)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomeViewControllerCell.self, forCellWithReuseIdentifier: cellId)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
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
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = DisplayPhotoView()
//        vc.imageUrl = posts[indexPath.row].imageUrl
//        self.present(vc, animated: true, completion: nil)
//    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    
    func fetchUserPost(_ group:DispatchGroup , uid: String){
//        print("fretch user post :\(uid)")
        group.enter()
        Database.fetchUserWithUID(uid: uid) { (user) in
            let ref = Database.database().reference().child("posts").child(uid)
            ref.observe(.value, with: { (snapsnot) in
                guard let dictionary = snapsnot.value as? [String: Any] else { return }
//                print("No of post for user:" , dictionary.count ," For user", user.name)
                dictionary.forEach({ (key,value) in
                    let dict = value as! [String:Any]
                    var post = Post(user: user, dict: dict)
                    post.id = key
                    guard let currentId = Auth.auth().currentUser?.uid else {return }
                    self.tempPost.append(post)
                })
//                print("Group leave for user",user.name)
                group.leave()
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
//        height += view.frame.width
//        height += 50
//        height += 60
//
//        let post = self.posts[indexPath.row]
//        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//        let dummyCell = HomeViewControllerCell(frame: frame)
//
//        let lb = UILabel(frame: frame)
//        let temp = NSMutableAttributedString(string: "\(post.user.name)", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
//        temp.append(NSAttributedString(string: " \(post.caption)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.black]))
//        temp.append(NSAttributedString(string: "\n #funny #abc #noob\n", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.blue]))
//        temp.append(NSAttributedString(string: "View All 3 comments", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.gray]))
//        temp.append(NSAttributedString(string: "\n\(post.creationDate.timeAgoDisplay())" , attributes:[NSFontAttributeName: UIFont.systemFont(ofSize: 10) ,NSForegroundColorAttributeName:UIColor.gray]))
//        dummyCell.bottomlabel.attributedText = temp
//        lb.attributedText = temp
//        lb.prefer
//        print("Lb :" ,lb.frame.height)
//
//        let targetSize = CGSize(width: view.frame.width, height: 1000)
//        let estimatedSize = lb.systemLayoutSizeFitting(targetSize)
//
//        let height2 = max(height ,estimatedSize.height)
//        print("Estimate size: \(estimatedSize.height)")
//        return CGSize(width: view.frame.width, height: height2)
//
//    }
    
    
    

 
}


