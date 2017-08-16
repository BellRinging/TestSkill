//
//  TestFacebookViewController.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 14/8/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import SwiftyJSON

struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        
//        let user : User?
        
        init(rawResponse: Any?) {
            let abc = rawResponse as? NSDictionary
            print(abc)
            if let json = JSON(abc) as? JSON{
                let user = User(json: json)
                print(user)
                
            }
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name, first_name, last_name, email, picture.type(large)"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}

class TestFacebookViewController: UIViewController , LoginButtonDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button = LoginButton(readPermissions: [ .publicProfile ,.email ])
        button.center = view.center
        button.delegate = self
        
        view.addSubview(button)
        
        
        if AccessToken.current != nil{
            print("User already login")
            getEmail()
        }
    }
    
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        if result != nil{
            let accessToken = AccessToken.current
            guard let accessTokenString = accessToken?.authenticationToken else { return }
            
//            let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
//            
//            Auth.auth().signIn(with: credentials, completion: { (user, error) in
//                print("Login with facebook auth")
//                self.getEmail()
//            })

            
            
        }else {
            print("Fail to login")
        }
    }
    
    func getEmail(){
        
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            
            switch result {
            case .success(let response):
                print("Custom Graph Request Succeeded: \(response)")
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
        

    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("User logout")
    }
    

    
    
  
    
}
