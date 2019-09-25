
import Foundation
import SwiftyJSON
import Firebase
import GoogleSignIn
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

extension SiginViewController : GIDSignInDelegate,GIDSignInUIDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
      if error != nil {
        Utility.hideProgress()
        return
      }else{
        print("Sign In to Google")
        let userId = user.userID                  // For client-side use only!
//        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        let url = user.profile.imageURL(withDimension: 100)?.absoluteString
        
        let providerUser = ProviderUser(user_name: fullName, first_name: givenName, last_name: familyName ,email: email, img_url: url)
        Utility.providerUser = providerUser
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        self.firebaseLogin(credential, provider: "google")
  
        }
    }

    
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
                    let user = ProviderUser(user_name: userData.name, first_name: userData.firstName, last_name: userData.lastName, email: userData.email, img_url: userData.photoUrl)
                    Utility.providerUser = user
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
//            if(provider == "Facebook"){
//                self.getUserProfitFromFacebook()
//            }
            
            Utility.hideProgress()
            self.dismissLogin()
        })
    }
 

}

