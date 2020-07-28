
import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class GoogleDelegates: NSObject , GIDSignInDelegate {

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }else{
            guard let authentication = user.authentication else { return }
            print("Signed In by Google")
            var tempUser = ProviderUser()
            tempUser.userName = user.profile.name
            tempUser.firstName = user.profile.givenName
            tempUser.lastName = user.profile.familyName
            tempUser.email = user.profile.email
            tempUser.imgUrl = user.profile.imageURL(withDimension: 100)?.absoluteString
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            let tokenDict:[String: Any] = ["token": credential , "user": tempUser ]
            NotificationCenter.default.post(name: .loginCompleted, object: nil,userInfo: tokenDict)
      
        }
    }
}
