import SwiftUI
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth
import Promises
import CryptoKit
import AuthenticationServices

struct SocialLogin: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
        
    }

    func attemptLoginGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }
//
//    func attemptLoginApple() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
    
//    func performExistingAccountSetupFlows() {
//        // Prepare requests for both Apple ID and password providers.
//        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
//
//        // Create an authorization controller with the given requests.
//        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
//
  
    
    func attemptLoginFb(){
        if let vc = UIApplication.shared.windows.last?.rootViewController{
            LoginManager.shared.loginWithFacebook(controller: vc, { (token, error , userData) in
                guard let accesstoken = token else {return }
                let cred = FacebookAuthProvider.credential(withAccessToken: accesstoken)
                self.firebaseLogin(cred, provider: "facebook" ,user: userData!)
            })
        }
    }
    
    func firebaseLogin(_ credentials: AuthCredential , provider:String , user : ProviderUser) {
        Utility.showProgress()
        
        
        
        loginToFirebase(credentials).then { tempUser in
            return User.getById(id: tempUser.uid)
        }.then{ userObj in
            if userObj != nil{
                print("Profile already exist")
                NotificationCenter.default.post(name: .dismissSwiftUI, object: nil)
            }else{
                RegisterHelper.registerUserIntoDatabase(user)
                print("Profile created \(provider)")
                NotificationCenter.default.post(name: .dismissSwiftUI, object: nil)
            }
        }.catch{ err in
            print("Fail to create login into firebase")
            Utility.showAlert(message: err.localizedDescription)
        }.always {
            Utility.hideProgress()
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

    

//
}
