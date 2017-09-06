//
//  SiginExtension.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 18/8/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin
import SwiftyJSON



extension SiginViewController :LoginButtonDelegate{
    
    struct MyProfileRequest: GraphRequestProtocol {
        struct Response: GraphResponseProtocol {
            
            var user : User?
            
            init(rawResponse: Any?) {
                let abc = rawResponse as? NSDictionary
                print(abc)
                if let json = JSON(abc) as? JSON{
                    user = User(json: json)
//                    print(user)
                    
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
            let accessToken = AccessToken.current
            guard let accessTokenString = accessToken?.authenticationToken else { return }
            
//                        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
//            
//                        Auth.auth().signIn(with: credentials, completion: { (user, error) in
//                            print("Login with facebook auth")
//                            self.getEmail()
//                        })
            
            
            
        }else {
            print("Fail to login")
        }
    }
    
}
