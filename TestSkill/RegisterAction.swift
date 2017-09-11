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


extension RegisterViewController {
    
    func showError(message : String){
        let error = PopupDialog()
        error.delegrate = self
        error.message = message
        error.messageLabel.sizeToFit()
        error.showDialog()
    }
    
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
            self.updateDisplayName(name: username )
        }
    }
    
    func updateDisplayName(name:String ){
        guard let user = Auth.auth().currentUser else {
            Utility.hideProgress()
            return
        }
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

    
    func showPopUpDialog(message : String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default)
        {
            (UIAlertAction) -> Void in
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
        {
            () -> Void in
        }
        
    }
}
