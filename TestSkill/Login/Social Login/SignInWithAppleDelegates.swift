
import UIKit
import AuthenticationServices
import Contacts
import Promises
import Firebase

class SignInWithAppleDelegates: NSObject , ASAuthorizationControllerDelegate {
   // private let signInSucceeded: (Bool) -> Void
//    private weak var window: UIWindow!
    
//    init() {
//        self.window =
//        self.signInSucceeded = onSignedIn
//    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: Utility.currentNonce)
            if let _ = appleIDCredential.email, let _ = appleIDCredential.fullName {
                print(appleIDCredential.fullName?.givenName)
                let userData = ProviderUser(userName: "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "" )", firstName: appleIDCredential.fullName?.givenName, lastName: appleIDCredential.fullName?.familyName, email: appleIDCredential.email, imgUrl: "https://firebasestorage.googleapis.com/v0/b/testlearning-6237e.appspot.com/o/profile_images%2Fi5v6MXXS9oS5kYZZGz4YSAiSKZr1%2FprofilePic.jpg?alt=media&token=eb8e07eb-2ff1-4490-870a-51abc578fba1")
                UserDefaults.standard.save(customObject: userData, inKey: UserDefaultsKey.AppleIdUser)
                firebaseLogin(credential,provider: "Apple" ,user: userData)
            }else{
                let user = UserDefaults.standard.retrieve(object: ProviderUser.self, fromKey: UserDefaultsKey.AppleIdUser)
                print(user)
                firebaseLogin(credential,provider: "Apple" ,user: user)
            }
        }else{
            print("Error in sign")
        }
        
    }
    
    func loginToFirebase(_ credentials: AuthCredential) -> Promise<FirebaseAuth.User> {
        let p = Promise<FirebaseAuth.User> { (resolve , reject) in
            Auth.auth().signIn(with: credentials, completion: { (result, err) in
                guard let user = result?.user else {
                    reject(err!)
                    return
                }
                UserDefaults.standard.set(1, forKey: UserDefaultsKey.LoginFlag)
                resolve(user)
            })
        }
        return p
    }
    
    func firebaseLogin(_ credentials: AuthCredential , provider:String , user : ProviderUser?) {
        Utility.showProgress()
        
        loginToFirebase(credentials).then { tempUser in
            return User.getById(id: tempUser.uid)
        }.then{ userObj in
            if userObj != nil{
                print("Profile already exist")
                NotificationCenter.default.post(name: .dismissSwiftUI, object: nil)
            }else{
                if let user = user {
                RegisterHelper.registerUserIntoDatabase(user)
                print("Profile created \(provider)")
//                self.signInSucceeded(true)
                }
                NotificationCenter.default.post(name: .dismissSwiftUI, object: nil)
            }
        }.catch{ err in
            print("Fail to create login into firebase")
            Utility.showAlert(message: err.localizedDescription)
        }.always {
            Utility.hideProgress()
        }
    }
}
