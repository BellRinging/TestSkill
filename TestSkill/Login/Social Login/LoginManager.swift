//
//  LoginManager.swift
//  ReuseabelLogInComponets
//
//  Created by Sumit Goswami on 09/03/18.
//  Copyright © 2018 Simform Solutions PVT. LTD. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Promises


public class LoginManager {
    
    public static let shared = LoginManager()
    
    let facebookManger = FBSDKLoginKit.LoginManager()
    
    public func facebookConfiguration(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)  {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }


    public func facebookUrlConfiguration(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    public func faceboolUrlConfigurationWithOptions(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url , options: options)
    }
//
    
    public func loginWithFacebook(permission:[ReadPermissions]? = nil,requriedFields:[NeededFields]? = nil,controller:UIViewController,_ completion:@escaping (String?, Error? , ProviderUser?)->())  {
                
        loginFacebook(permission: permission, controller: controller).then{ token in
            return self.getDataFromFacebook(token: token)
        }.then { (arg)  in
            let (user, token) = arg
            completion(token,nil,user)
        }.catch { (err) in
            Utility.showAlert(message: err.localizedDescription)
            completion(nil,err,nil)
        }
            
        
    }
    private func loginFacebook(permission:[ReadPermissions]? = nil,controller:UIViewController) -> Promise<String>  {
        let p = Promise<String> { (resolve , reject) in
            let permission = self.getReadPermission(readPermission: permission)
            self.facebookManger.logIn(permissions: permission, from: controller, handler: { (result, error) in
                
                if let unwrappedError = error {
                    self.facebookManger.logOut()
                    reject(unwrappedError)
                } else if (result?.isCancelled)! {
                    self.facebookManger.logOut()
                    reject(FacebookError.facebookCancel)
                } else if (result == nil){
                    reject(FacebookError.facebookNoResult)
                }else{
                    if let tok = result?.token?.tokenString{
                        resolve(tok)
                    }else{
                        reject(FacebookError.facebookNoResult)
                    }
                }
            })
        }
        return p
    }
    
    
    private func getDataFromFacebook(token:String,requriedFields:[NeededFields]? = nil) -> Promise<(ProviderUser,String)> {
             
        let p = Promise<(ProviderUser,String)> { (resolve , reject) in
            GraphRequest.init(graphPath: "me", parameters:["fields":self.getNeededFields(requiredPermission: requriedFields)] ).start(completionHandler: { (connection, response, meError) in
                if let unwrappedMeError = meError {
                    reject(unwrappedMeError)
                }else{
                    let userData = self.parseUserData(dataResponse: response as AnyObject)
                    resolve((userData,token))
                }
            })
        }
        return p
    }
    
    
    private func getReadPermission(readPermission:[ReadPermissions]?) -> [String] {
        var permissionString:[String] = [String]()
        if readPermission == nil {
           return FacebookConstante.readPermissions
        } else {
            for value in readPermission! {
                permissionString.append(value.rawValue)
            }
        }
        return permissionString
    }
    
    
    private func getNeededFields(requiredPermission:[NeededFields]?) -> String {
        var permissionString:String = ""
        if requiredPermission == nil {
            return FacebookConstante.neededFields
        } else {
            for value in requiredPermission! {
                permissionString.append(value.rawValue)
                if value.rawValue != requiredPermission?.last?.rawValue {
                    permissionString.append(",")
                }
            }
        }
        return permissionString
    }
 
    
    private func showPopUp(viewController:UIViewController) {
        let alert = UIAlertController(title: "Permissions Declined", message: "please give all permissions needed to sigup user", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private func parseUserData(dataResponse:AnyObject) -> ProviderUser {
//        var userData = UserData()
        var userData = ProviderUser()
        
//        if let about = dataResponse.object(forKey: NeededFields.about.rawValue) as? String {
//           userData.about = about
//        }
//        if let birthday = dataResponse.object(forKey: NeededFields.birthday.rawValue) as? String {
//           userData.birthday = birthday
//        }
        if let email = dataResponse.object(forKey: NeededFields.email.rawValue) as? String {
           userData.email = email
        }
        if let firstName = dataResponse.object(forKey: NeededFields.firstName.rawValue) as? String {
           userData.firstName = firstName
        }
        if let lastName = dataResponse.object(forKey: NeededFields.lastName.rawValue) as? String {
           userData.lastName = lastName
        }
//        if let gender = dataResponse.object(forKey: NeededFields.gender.rawValue) as? String {
//           userData.gender = gender
//        }
        if let name = dataResponse.object(forKey: NeededFields.name.rawValue) as? String {
           userData.userName = name
        }
//        if let id = dataResponse.object(forKey: NeededFields.id.rawValue) as? String {
//           userData.id = id
//        }
        if let picture = dataResponse.object(forKey: NeededFields.picture.rawValue) as? NSDictionary {
            if let data = picture.value(forKey: "data") as? NSDictionary {
                userData.imgUrl = data.value(forKey:"url")! as! String
            }
        }
        return userData
    }
    
}


