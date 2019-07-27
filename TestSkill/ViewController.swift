//
//  ViewController.swift
//  TestProblem
//
//  Created by Kwok Wai Yeung on 28/12/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//
import Firebase
import UIKit

class ViewController: UIViewController ,UICollectionViewDataSource ,UICollectionViewDelegate  ,UICollectionViewDelegateFlowLayout   {
    var collectionView : UICollectionView?
    
    var post: Post?
    var con : NSLayoutConstraint?
    var comments  = [Comment]()
        let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView?.backgroundColor = .red
        collectionView?.translatesAutoresizingMaskIntoConstraints=false
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        //        collectionView.backgroundColor = UIColor.red
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(CommentViewControllerCell.self, forCellWithReuseIdentifier: cellId)
        setupLayout()
        fetchComment()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: Notification.Name.UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: Notification.Name.UIResponder.keyboardWillShowNotification, object: nil)
//        view.addSubview(collectionView!)
//        collectionView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupLayout(){
        view.addSubview(collectionView!)
        view.addSubview(containerView)
        //        collectionView.layer.borderWidth = 1
        //        collectionView.layer.borderColor = UIColor.brown.cgColor
        collectionView?.Anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: containerView.topAnchor, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        
        containerView.Anchor(top: collectionView!.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.con = view.heightAnchor.constraint(equalToConstant: 100)
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        self.con?.isActive = true
        
        
    }
    
    
    
    
    
    func fetchComment(){
        self.comments.removeAll()
        guard let postId = post?.id else {return}
        let ref = Database.database().reference().child("comments").child(postId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {return}
            
            
            guard let uid = dict["uid"] as? String else { return }
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                let comment = Comment(user: user, dictionary: dict)
                self.comments.append(comment)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            })
        })
    }
    
    func collectionView(_ : UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentViewControllerCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        return CGSize(width: view.frame.width, height: height)
    }
    lazy var commentTextField: UITextView = {
        let textField = UITextView()
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.font = UIFont.systemFont(ofSize: 16)
//        textField.delegate = self
        textField.addSubview(self.placeholderLabel)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isScrollEnabled = false
        //        textField.layer.borderWidth = 1
        //        textField.layer.borderColor = UIColor.blue.cgColor
        self.placeholderLabel.Anchor(top: nil, left: textField.leftAnchor, right: nil, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        self.placeholderLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        return textField
    }()
    
    
    
    lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Enter some text..."
        placeholderLabel.textColor = UIColor.lightGray
        return placeholderLabel
    }()
    
    
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        //        containerView.layer.borderColor = UIColor.red.cgColor
        //        containerView.layer.borderWidth = 1
        containerView.backgroundColor = .white
        //        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)

        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.Anchor(top: containerView.topAnchor, left: nil, right: containerView.rightAnchor, bottom: containerView.bottomAnchor, topPadding: 0, leftPadding: 0, rightPadding: 12, bottomPadding: 0, width: 50, height: 0)
        containerView.addSubview(self.commentTextField)
        self.commentTextField.Anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: submitButton.leftAnchor, bottom: containerView.bottomAnchor, topPadding: 0, leftPadding: 12, rightPadding: 0, bottomPadding: 0, width: 0)
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        containerView.addSubview(lineSeparatorView)
        lineSeparatorView.Anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0.5)
        return containerView
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        commentTextField.becomeFirstResponder()
    }
//
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
        con?.isActive = false
        view.translatesAutoresizingMaskIntoConstraints = true
    }

    
    func keyboardWillAppear(_ sender:NSNotification) {
//        //Do something here
        let info = sender.userInfo!
        let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        print("keyboard show")
        
        let const = view.constraints
        print(const.count)
//        const.forEach { (const) in
//            print(const)
//        }
        con?.isActive = false
        con?.constant = UIScreen.main.bounds.height - keyboardHeight
        con?.isActive = true
    }
//
    @objc func keyboardWillDisappear(_ sender:NSNotification) {
        print("keyboard hide")
        con?.isActive = false
////        con?.constant = UIScreen.main.bounds.height
////        con?.isActive = true
//
    }

}

