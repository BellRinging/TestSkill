//
//  ProfitSetupController.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 23/8/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD

class ProfileSetupController : UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    
    var user : User?{
        didSet{
            userNameLabel.text = user?.user_name
            firstNameField.text = user?.first_name
            lastNameField.text = user?.last_name
            emailField.text = user?.email
            if let url = user?.img_url ,url != ""{
                imageView.loadImage(url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Utility.user {
            self.user = user
        }else {
            if let firebaseUser = Utility.firebaseUser {
                let displayName = firebaseUser.displayName ?? ""
                let email = firebaseUser.email ?? ""
                if let url = firebaseUser.photoURL?.absoluteString {
                    let dict = ["name": displayName,"img_url": url,"email" : email , "id" :firebaseUser.uid ]
                    let userObject = User(dict: dict)
                    self.user = userObject
                }else{
                    let dict = ["name": displayName,"email" : email , "id" :firebaseUser.uid ]
                    let userObject = User(dict: dict)
                    self.user = userObject
                }
            }
        }
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        
        view.addDefaultGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           setupView()
    }
    
    
    
    func setupView(){
        navigationItem.titleView?.addDefaultGradient()
        let barButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleProfileCreation))
        navigationItem.rightBarButtonItem = barButton
        
        
        view.addSubview(imageView)
        imageView.Anchor(top: topLayoutGuide.bottomAnchor, left: nil, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 80 , height: 80)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(userNameLabel)
        userNameLabel.Anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(firstNameField)
        firstNameField.Anchor(top: userNameLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
        view.addSubview(lastNameField)
        lastNameField.Anchor(top: firstNameField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
        
        view.addSubview(emailField)
        emailField.Anchor(top: lastNameField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
    }
    
    
    lazy var imageView : CustomImageView = {
        let im = CustomImageView()
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        im.image = #imageLiteral(resourceName: "empty-avatar")
        im.layer.cornerRadius = 80/2
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapImage)))
        im.isUserInteractionEnabled = true
        return im
    }()

    let userNameLabel : UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    
    let firstNameField : FloatLabelTextField = {
        let tv = FloatLabelTextField()
        tv.fakePlaceholder = "First Name"
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.backgroundColor = UIColor.white
//        tv.titleTextColour = UIColor.black
//        tv.titleActiveTextColour = UIColor.black
        tv.addBottomBorder(UIColor.gray, thickness: 0.5)
        tv.clearButtonMode = UITextField.ViewMode.always
        return tv
    }()
    
    let lastNameField : FloatLabelTextField = {
        let tv = FloatLabelTextField()
        tv.fakePlaceholder = "Last Name"
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.backgroundColor = UIColor.white
//        tv.titleTextColour = UIColor.black
        tv.addBottomBorder(UIColor.gray, thickness: 0.5)
        tv.clearButtonMode = UITextField.ViewMode.always
        
        return tv
    }()
    
    let emailField : FloatLabelTextField = {
        let tv = FloatLabelTextField()
        tv.fakePlaceholder = "Email"
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.backgroundColor = UIColor.white
//        tv.titleTextColour = UIColor.black
        //        tv.titleActiveTextColour = UIColor.black
        tv.addBottomBorder(UIColor.gray, thickness: 0.5)
        tv.clearButtonMode = UITextField.ViewMode.always
        return tv
    }()
    

    
    

    static let updateProfile = NSNotification.Name(rawValue: "UpdateProfile")

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        
        var selectedImage: UIImage?

         if let editedImage = info[.editedImage] as? UIImage {
             selectedImage = editedImage
         } else if let originalImage = info[.originalImage] as? UIImage {
             selectedImage = originalImage
         }
        DispatchQueue.main.async {
            self.imageView.image = selectedImage
        }
         dismiss(animated: true, completion: nil)
    }
    
    
    
}
