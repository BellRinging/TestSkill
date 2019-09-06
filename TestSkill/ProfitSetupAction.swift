//
//  ProfitSetupAction.swift
//  TestSkill
//
//  Created by Kenny Yeung on 5/9/2019.
//  Copyright © 2019 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import Promises
import Firebase



extension ProfileSetupController {
    
    @objc func handleTapImage(){
           print("tap Image")
           let controller = UIImagePickerController()
           controller.allowsEditing = true
           controller.delegate = self
           self.present(controller, animated: true, completion: nil)
    }
    

    @objc func handleProfileCreation(){
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
        guard let userName = userNameLabel.text else { return }
        
        print("Start upload profile img")
        uploadImage(uid: user.uid).then { url in
            print("Start create profile")
            let values = [ "last_name": lastName, "first_name": firstName ,"email" : email , "img_url" : url , "name" : userName ,"id" : user.uid]
            self.registerUserIntoDatabaseWithUID(values: values)
            print("Profile created")
            UserDefaults.standard.set(true, forKey: StaticValue.LOGINKEY)
            self.dismiss(animated: true, completion: nil)
        }.always {
            Utility.hideProgress()
        }.catch { (error) in
            Utility.showError(self,message: error.localizedDescription)
        }
                
    }
    
    func uploadImage(uid: String) -> Promise<String> {
     let p = Promise<String> { (resolve , reject) in
        let ref = Storage.storage().reference().child("profile_images").child(uid).child("profilePic.jpg")
        if let profileImage = self.imageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
            ref.putData(uploadData, metadata: nil) { (metaData, error) in
                if let error = error{
                    reject(error)
                    return
                }
                ref.downloadURL { (url, err) in
                    if let err = err{
                        reject(err)
                        return
                    }
                    let profileImageURL = url!.absoluteString
                    resolve(profileImageURL)
                }
            }
        }
         
     }
     return p
 }

    
    func registerUserIntoDatabaseWithUID(values: [String: String]) {
        guard let uid = Auth.auth().currentUser?.uid else {return }
        let ref = Firestore.firestore()
        let usersReference = ref.collection("users").document(uid)
        usersReference.setData(values)
    }
    
       
    
}
