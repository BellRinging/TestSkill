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
    
    
    var userName : String? {
        didSet{
            userNameLabel.text = userName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addDefaultGradient()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
           setupView()
    }
    
    
    
    func setupView(){
        
        let barButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleCreation))
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
//    
    lazy var progressIcon : MBProgressHUD = {
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.labelText = "Loading"
        prog.isUserInteractionEnabled = false
        return prog
    }()
//
//    
    let createProfileButton : UIButton = {
        let bn = UIButton()
        let text = NSAttributedString(string: "Create Profile Now", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white])
        bn.setAttributedTitle(text, for: .normal)
        bn.addTarget(self, action: #selector(handleCreation), for: .touchUpInside)
        bn.layer.borderWidth = 0.5
        bn.layer.borderColor = UIColor.white.cgColor
        return bn
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
        tv.titleTextColour = UIColor.black
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
        tv.titleTextColour = UIColor.black
//        tv.titleActiveTextColour = UIColor.black
        tv.addBottomBorder(UIColor.gray, thickness: 0.5)
        tv.clearButtonMode = UITextFieldViewMode.always
        
        return tv
    }()
    
    func updateUserImage(url : String){
        guard let user = Auth.auth().currentUser else {return }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.photoURL = URL(string: url)
        changeRequest.commitChanges(completion: { (error) in
            print("Updated Profile Image")
            NotificationCenter.default.post(name: ProfileSetupController.updateProfile, object: nil)
            
        })
    }
  
    
    func handleCreation(){
        Utility.showProgress()
        guard let uid = Auth.auth().currentUser?.uid else {return }
        guard let firstName = firstNameField.text else { return }
        guard let lastName = lastNameField.text else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        
        let ref = Storage.storage().reference().child("profile_images").child(uid).child("profilePic.jpg")
        if let profileImage = self.imageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            ref.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                if (error != nil){
                    print("some bad happend in put image to server")
                    Utility.hideProgress()
                    return
                }
                if let profileImageURL = metaData?.downloadURL()?.absoluteString{
                    self.updateUserImage(url: profileImageURL)
                    let values = [ "last_name": lastName, "first_name": firstName, "email": email]
                    self.registerUserIntoDatabaseWithUID(values: values as [String : AnyObject])
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
                self.progressIcon.hide(animated: true)
                return
            }

//            let user = User(dict: values)
//            print(user)
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
