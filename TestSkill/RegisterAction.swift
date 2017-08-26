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
        let error = PopupDialog()
        error.delegrate = self

        guard let email = validField(emailField, "Email is required.Please enter your email"),
            let password = validField(passwordField,"Password is required.Please enter your number"),
            let _ = validField(firstNameField, "Frist name is required.Please enter your first name "),
            let _  = validField(lastNameField,   "Last name is required.Please enter you last name") else {
//                let error = PopupDialog()
                error.message = errorMessage
                error.showDialog()
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            
            if let err = err{
                error.message = err.localizedDescription
                error.messageLabel.sizeToFit()
                error.showDialog()
//                self.showPopUpDialog(message: "Some bad happen when create user")
                print(err)
                return
            }
            
            guard let _ = user?.uid else {
                return
            }
            print("User created")
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
