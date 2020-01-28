//
//  ChatDetailViewModel.swift
//  QBChat-MVVM
//
//  Created by Paul Kraft on 30.10.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import Promises
import SwiftUI





class LoginViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showRegisterPage: Bool = false
    var sampleDataForPageView : [PageViewArea]
    
    init(){
        let dao = [
             Page(title: "This is title", image: Image("fontPageImage3"), massage: "This is message"),
             Page(title: "This is title", image: Image("fontPageImage2"), massage: "This is message"),
             Page(title: "This is title", image: Image("fontPageImage1"), massage: "This is message")
         ]
        sampleDataForPageView  = dao.map{PageViewArea(inputDO: $0)}
    }
    
    
    func normalLogin(){
        print("SignIn by Email")
        if self.validField() {
            Utility.showProgress()
            normalLoginByUser(email: email, password: password).then { user in
                 NotificationCenter.default.post(name: .dismissSwiftUI, object: nil)
            }.catch { (err) in
                Utility.showError(message: err.localizedDescription)
            }.always {
                Utility.hideProgress()
            }
        }
    }
    
    func validField() -> Bool{
        if email == "" {
            Utility.showError( message: "Email is required.Please enter your email")
            return false
        }
        
        if password == "" {
            Utility.showError(message: "Password is required.Please enter your number")
            return false
        }
        return true
    }
    
    func normalLoginByUser(email:String,password:String) ->Promise<FirebaseAuth.User>{
         let p = Promise<FirebaseAuth.User> { (resolve , reject) in
             Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                 if let err = error {
                     reject(err)
                 }
                 print("login by email success ,show main page")
                 resolve(result!.user)
             }
         }
         return p
     }
}
