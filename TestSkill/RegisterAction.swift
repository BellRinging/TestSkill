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


extension RegisterViewController {
    

    
    func handleRegister(){
        Utility.showProgress()
        guard let email = validField(emailField, "Email is required.Please enter your email"),
            let password = validField(passwordField,"Password is required.Please enter your number"),
            let username = validField(userNameField, "User name is required.Please enter your username ") else {
                self.showError(message: errorMessage)
                Utility.hideProgress()
                return
        }
        
        print("Create login into firebase")
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            
            if let err = err{
                self.showError(message: err.localizedDescription)
                Utility.hideProgress()
                return
            }
            
            guard let uid = user?.uid else {
                Utility.hideProgress()
                return
            }
            
            print("User created")
            self.updateDisplayName(user!, name: username )
        }
    }
    
    func updateDisplayName(_ user: Firebase.User , name:String ){
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges(completion: { (error) in
            if let err = error {
                print(err.localizedDescription)
                Utility.hideProgress()
                return
            }
            print("Updated Display Name")
            self.dismissLogin()
        })
    }
    
    func dismissLogin(){
        print("Dismiss the login controller")
        self.dismiss(animated: true, completion: nil)
        self.delegrate?.dismiss(animated: true, completion: nil)
    }
    

    func validField(_ field:UITextField, _ message:String) -> String?{
        if let fieldValue = field.text, fieldValue != "" { return fieldValue }
        errorMessage = message
        return nil
    }

    

}
