
import Foundation
import SwiftyJSON
import Firebase
import GoogleSignIn
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

extension SiginViewController{
    
//    private let readPermissions: [ReadPermission] = [ .publicProfile, .email ]
    
    
    
    @objc func SignInByGoogle(){
        Utility.showProgress()
         GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func SignInByFacebook(){
        Utility.showProgress()
        LoginManager.shared.loginWithFacebook(controller: self, { (token, error) in
           if error == nil {
               print( token?.userID ?? "",token?.tokenString ?? "")
           }else {
                print("Fail to login")
                return
            }
            if let accesstoken = token {
                let cred = FacebookAuthProvider.credential(withAccessToken: accesstoken.tokenString)
                self.firebaseLogin(cred, provider: "facebook")
            }
           
           })
        { (result, error) in
//
               if error == nil {
                   if let userData = result as? UserData {
                    
                       print(userData)
                       print(userData.id)
                   } else {
                       print(result ?? "")
                   }
               }
           }
    }
    
    
    func firebaseLogin(_ credentials: AuthCredential , provider:String) {
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print(err.localizedDescription)
                Utility.hideProgress()
                return
            }
            
            print("Login by \(provider)")
            if(provider == "Facebook"){
//                self.getUserProfitFromFacebook()
            }
            
            Utility.hideProgress()
            self.dismissLogin()
        })
    }
 

}

