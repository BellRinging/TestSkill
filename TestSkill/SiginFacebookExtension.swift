
import Foundation
import FacebookCore
import FacebookLogin
import SwiftyJSON
import Firebase

extension SiginViewController :LoginButtonDelegate{
    
    struct MyProfileRequest: GraphRequestProtocol {
        struct Response: GraphResponseProtocol {
            
            var user : User?
            
            init(rawResponse: Any?) {
                let abc = rawResponse as? NSDictionary
                if let json = JSON(abc) as? JSON{
                    user = User(json: json)
                    print("return from response")
                }
            }
        }
        
        var graphPath = "/me"
        var parameters: [String : Any]? = ["fields": "id, name, first_name, last_name, email, picture.type(large)"]
        var accessToken = AccessToken.current
        var httpMethod: GraphRequestHTTPMethod = .GET
        var apiVersion: GraphAPIVersion = .defaultVersion
    }

    
    
    func getEmail(){
        
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response):
                guard let user = response.user else {return}
                print("Custom Graph Request Succeeded: \(user)")
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("User logout")
    }
    
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        if result != nil{
            Utility.showProgress()
            print("User is logined by facebook")
            let accessToken = AccessToken.current
            guard let accessTokenString = accessToken?.authenticationToken else { return }
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
//            firebaseLogin(credentials)
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                Utility.hideProgress()
                print("Login to fairbase with facebook auth")
                self.getEmail()
                self.dismissLogin()
            })
            
        }else {
            print("Fail to login")
        }
    }
    
    func firebaseLogin(_ credentials: AuthCredential) {
        Utility.showProgress()
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            Utility.hideProgress()
            print("Login fail  fairbase with facebook auth")
            self.getEmail()
            self.dismissLogin()
        })
    }
    
}
