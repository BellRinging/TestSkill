//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 4/1/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class SharePhotoController: UIViewController {
    
    
    var editFlag :Int = 0
    var post :Post?{
        didSet{
            textView.text = post?.caption
            imageView.loadImage(post!.imageUrl)
        }
    }
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        setupImageAndTextViews()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationButtons()
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        if (editFlag == 0){
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        }else{
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleEdit))
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    
    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        
        
        containerView.Anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 100)
    
        
        containerView.addSubview(imageView)
        
        imageView.Anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: nil, bottom: containerView.bottomAnchor, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 8, width: 84, height: 0)
    
        containerView.addSubview(textView)
        
        textView.Anchor(top: containerView.topAnchor, left: imageView.rightAnchor, right: containerView.rightAnchor, bottom: containerView.bottomAnchor, topPadding: 0, leftPadding: 4, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        
    }
    
    @objc func handleShare() {
        guard let caption = textView.text, caption.count > 0 else { return }
        guard let image = selectedImage else { return }
        
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference().child("posts").child(filename)
        ref.putData(uploadData, metadata: nil) { (metadata, err) in
            
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image:", err)
                return
            }
            
            ref.downloadURL { (url, err) in
                
                guard let imageUrl = url?.absoluteString else { return }
                print("Successfully uploaded post image:", imageUrl)
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            }
            
            
        }
    }
    
    @objc func handleEdit() {
        
        guard let caption = textView.text, caption.count > 0 else { return }
        guard let post = post else { return }
        let userId = post.user.id
        navigationItem.rightBarButtonItem?.isEnabled = false
        let ref = Database.database().reference().child("posts").child(userId).child(post.id!)
        let values = ["imageUrl": post.imageUrl, "caption": caption, "imageWidth": imageView.image?.size.width, "imageHeight": imageView.image?.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: ProfileSetupController.updateProfile, object: nil)
        }
    }
    
   
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: ProfileSetupController.updateProfile, object: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
   
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}

