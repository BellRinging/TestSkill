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
            userNameLabel.text = user?.name
            firstNameField.text = user?.firstName
            lastNameField.text = user?.lastName
            emailField.text = user?.email
            if let url = user?.imageUrl {
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
                print("URL \(firebaseUser.photoURL)")
                let url = firebaseUser.photoURL?.absoluteString
                let dict = ["name": firebaseUser.displayName,"img_url": url,"email" : firebaseUser.email , "id" :firebaseUser.uid ] as [String : Any]
                let userObject = User(dict: dict)
                self.user = userObject
            }
        }
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
        tv.clearButtonMode = UITextFieldViewMode.always
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
        tv.clearButtonMode = UITextFieldViewMode.always
        
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
        tv.clearButtonMode = UITextFieldViewMode.always
        return tv
    }()
    
    func handleProfileCreation(){
        Utility.showProgress()
        
        guard let user = Auth.auth().currentUser else {return }
        
        guard
            let _ = Utility.validField(firstNameField, "First Name is required.Please enter your email"),
            let _ = Utility.validField(lastNameField,"Password is required.Please enter ") ,
            let _ = Utility.validField(emailField,"Email is required.Please enter") else {
                Utility.showError(self,message: Utility.errorMessage!)
                Utility.hideProgress()
                return
        }
      
        guard let firstName = firstNameField.text else { return }
        guard let lastName = lastNameField.text else { return }
        guard let email = emailField.text else { return }
    
        let ref = Storage.storage().reference().child("profile_images").child(user.uid).child("profilePic.jpg")
        if let profileImage = self.imageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            ref.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                if (error != nil){
                    print("some bad happend in put image to server")
                    Utility.hideProgress()
                    return
                }
                print("upload image")
                if let profileImageURL = metaData?.downloadURL()?.absoluteString{
                    let values = [ "last_name": lastName, "first_name": firstName ,"email" : email , "img_url" : profileImageURL , "name" : self.userNameLabel.text ,"id" : user.uid]
                    self.registerUserIntoDatabaseWithUID(values: values as [String : AnyObject])
                    NotificationCenter.default.post(name: ProfileSetupController.updateProfile, object: nil)
                }
            })
        }
    }
    
    
    
    
    fileprivate func registerUserIntoDatabaseWithUID( values: [String: AnyObject]) {
        guard let uid = Auth.auth().currentUser?.uid else {return }
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                Utility.hideProgress()
                return
            }
            Utility.hideProgress()
            self.dismiss(animated: true, completion: nil)
        })
    }
    

    static let updateProfile = NSNotification.Name(rawValue: "UpdateProfile")
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
   
    func handleTapImage(){
        print("tap Image")
        let controller = UIImagePickerController()
        controller.allowsEditing = true
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
}
