
import Foundation
import SwiftyJSON
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

extension SiginViewController :LoginButtonDelegate{
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
       /*
        switch result {
        case.failed(let error):
            Utility.hideProgress()
            Utility.showPopUpDialog(viewController: self, message: "Fail to login facebook",completion: {
                action in
                
            })
            return
        case .cancelled:
            Utility.hideProgress()
            print("User cancelled login.")
            return
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            Utility.showProgress()
            print("User is logined by facebook")
            let accessToken = AccessToken.current
            guard let accessTokenString = accessToken?.authenticationToken else { return }
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            firebaseLogin(credentials,provider:"Facebook")
        }
 */
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
          print("Did logout via LoginButton")
        }
    
//    struct FacebookProfileRequest: GraphRequestProtocol {
//        struct Response: GraphResponseProtocol {
//            var user : User?
//            init(rawResponse: Any?) {
//                let abc = rawResponse as? NSDictionary
//                if let json = JSON(abc) as? JSON{
//                    user = User(json: json)
//                }
//            }
//        }
//        var graphPath = "/me"
//        var parameters: [String : Any]? = ["fields": "id, name, first_name, last_name, email, picture.type(large)"]
//        var accessToken = AccessToken.current
//        var httpMethod: GraphRequestHTTPMethod = .GET
//        var apiVersion: GraphAPIVersion = .defaultVersion
//    }
    
    
    func getUserProfitFromFacebook(){
//        let connection = GraphRequestConnection()
//        connection.add(FacebookProfileRequest()) { response, result in
//            switch result {
//            case .success(let response):
//                guard let user = response.user else {return}
//                Utility.user = user
//            case .failed(let error):
//                Utility.hideProgress()
//                print("Custom Graph Request Failed: \(error)")
//            }
//        }
//        connection.start()
        let request = GraphRequest(graphPath: "/me",
                                           parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"],
                                           httpMethod: .get)
        request.start { (conn, result, err) in
            
//            switch result {
//            case .success(let response):
//                guard let user = response.user else {return}
//                Utility.user = user
//            case .failed(let error):
//                Utility.hideProgress()
//                print("Custom Graph Request Failed: \(error)")
//            }
            
//             var user : User?
            //            init(rawResponse: Any?) {
            //                let abc = rawResponse as? NSDictionary
            //                if let json = JSON(abc) as? JSON{
            //                    user = User(json: json)
            //                }
            //            }
        }
                  
        
        
    }
    
    
    func firebaseLogin(_ credentials: AuthCredential , provider:String) {
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                Utility.hideProgress()
                print(error?.localizedDescription)
                return
            }
            
            print("Login by \(provider)")
            if(provider == "Facebook"){
                self.getUserProfitFromFacebook()
            }
            self.dismissLogin()
        })
    }

}

extension SiginViewController : GIDSignInUIDelegate {
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
//        myActivityIndicator.stopAnimating()
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
}

