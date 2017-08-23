//
//  LoginAction.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 23/8/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import FirebaseAuth


extension RegisterViewController {
    
  
    
    func handleRegister(){
    
        guard let email = validField(emailField, "Email is required.Please enter your email"),
            let password = validField(passwordField,"Password is required.Please enter your number"),
            let firstName = validField(firstNameField, "Frist name is required.Please enter your first name "),
            let lastName  = validField(lastNameField,   "Last name is required.Please enter you last name") else {
                self.showPopUpDialog(message: errorMessage)
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if (error != nil){
                self.showPopUpDialog(message: "Some bad happen when create user")
                return
            }
            guard let uid = user?.uid else {
                return
            }
            print("User create")
        }
    }
    

    func validField(_ field:UITextField, _ message:String) -> String?
    {
        if let fieldValue = field.text, fieldValue != ""
        { return fieldValue }
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
