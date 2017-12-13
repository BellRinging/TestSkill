//
//  CommentViewController.swift
//  SnookerGambling
//
//  Created by Kwok Wai Yeung on 11/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CommentViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    
    
    var post: Post?{
        didSet{
            //            fetchComment()
        }
    }
    
    var comments  = [Comment]()
    
    func fetchComment(){
        self.comments.removeAll()
        
        //        print("fetch comment")
        
        guard let postId = post?.id else {return}
        let ref = Database.database().reference().child("comments").child(postId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {return}
            
            
            guard let uid = dict["uid"] as? String else { return }
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                let comment = Comment(user: user, dictionary: dict)
                self.comments.append(comment)
                self.collectionView?.reloadData()
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(CommentViewControllerCell.self, forCellWithReuseIdentifier: cellId)
        
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)

        fetchComment()
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentViewControllerCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentViewControllerCell(frame: frame)
        dummyCell.comment = comments[indexPath.row]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        //        print("Estimate size: \(estimatedSize.height)")
        return CGSize(width: view.frame.width, height: height)
    }
    
    func handleSubmit() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        //        print("post id:", self.post?.id ?? "")
        //        print("Inserting comment:", commentTextField.text ?? "")
        
        let postId = self.post?.id ?? ""
        let values = ["text": commentTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        //        print(postId)
        
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            
            if let err = err {
                print("Failed to insert comment:", err)
                return
            }
            self.commentTextField.text = ""
            print("Successfully inserted comment.")
        }
    }
    
    
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        
        submitButton.Anchor(top: containerView.topAnchor, left: nil, right: containerView.rightAnchor, bottom: containerView.bottomAnchor, topPadding: 0, leftPadding: 0, rightPadding: 12, bottomPadding: 0, width: 50, height: 0)
        
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.Anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: submitButton.leftAnchor, bottom: containerView.bottomAnchor, topPadding: 0, leftPadding: 12, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        containerView.addSubview(lineSeparatorView)
        
        lineSeparatorView.Anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0.5)
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

