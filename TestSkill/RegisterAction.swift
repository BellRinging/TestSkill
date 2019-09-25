//
//  LoginAction.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 23/8/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import FirebaseAuth
import MBProgressHUD
import Firebase
import Promises


extension RegisterViewController {
    

    
    @objc func handleRegister(){
        Utility.showProgress()
        print("Create login into firebase")
        createUserInDb(email: self.emailField, password: self.passwordField).then {user in
            
            let name = self.userNameField.text
            let email = self.emailField.text
            let providerUser = ProviderUser(user_name: name, first_name: nil, last_name: nil, email: email, img_url: nil)
            Utility.providerUser = providerUser
            self.updateDisplayName(user, name: self.userNameField.text!)
        }.then { _ in
            self.dismissLogin()
        }.catch{ err in
            print("Fail to create login into firebase")
             Utility.showError(self, message: err.localizedDescription)
        }.always {
            Utility.hideProgress()
        }
     
    }
    
    func createUserInDb(email: UITextField,password : UITextField) -> Promise<FirebaseAuth.User>  {
        let p = Promise<FirebaseAuth.User> { (resolve , reject) in
            guard let email = Utility.validField(self.emailField, "Email is required.Please enter your email"),
                     let password = Utility.validField(self.passwordField,"Password is required.Please enter your number"),
                     let _ = Utility.validField(self.userNameField, "User name is required.Please enter your username ") else {
                        let err = NSError(domain: Utility.errorMessage!, code: 777, userInfo: nil)
                            reject(err)

                         return
                 }
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                guard let user = result?.user else {
                    reject(err!)
                    return
                }
                resolve(user)
            }
        }
        return p
    }
    
    

    func updateDisplayName(_ user: Firebase.User , name:String ) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges(completion: { (error) in
            if let _ = error {
                return
            }
            print("Updated Display Name")
        })
    }
    
    @objc func dismissLogin(){
        print("Dismiss the login controller")
        self.dismiss(animated: true, completion: nil)
        self.delegrate?.dismiss(animated: true, completion: nil)
    }

}
