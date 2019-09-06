//
//  Helper.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 11/9/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import MBProgressHUD
import FirebaseAuth
import Firebase

class Utility {
    
    static func showProgress(){
        print("Show Progress")
        DispatchQueue.main.async {
            guard let mainWindow = UIApplication.shared.delegate?.window else { return }
            let progressIcon = MBProgressHUD.showAdded(to: mainWindow!, animated: true)
            progressIcon.labelText = "Loading"
            progressIcon.isUserInteractionEnabled = false
            //tempView
            
            let tempView = UIView(frame: (mainWindow?.frame)!)
            tempView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            tempView.tag = 999
            mainWindow?.addSubview(tempView)
            progressIcon.show(animated: true)
        }
    }
    
    static func hideProgress(){
        DispatchQueue.main.async {
            print("hide Progress")
            guard let mainWindow = UIApplication.shared.delegate?.window else { return }
            MBProgressHUD.hideAllHUDs(for: mainWindow!, animated: true)
            let view = mainWindow?.viewWithTag(999)
            view?.removeFromSuperview()
        }
    }
    
    static func showPopUpDialog(viewController:UIViewController, message : String ,completion: @escaping (UIAlertAction) -> ()){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK!", style: .default)
        {
            (action) -> Void in
            completion(action)
        }
        alert.addAction(alertAction)
        viewController.present(alert, animated: true)
        {
            () -> Void in
        }
    }
    
    static var errorMessage : String?
    
    static var firebaseUser : Firebase.User?
    
    static var fcmToken : String?
    
    static var user : User?
    
    static func validField(_ field:UITextField, _ message:String) -> String?{
        if let fieldValue = field.text, fieldValue != "" { return fieldValue }
        errorMessage = message
        return nil
    }
    
    static func showError(_ controller:UIViewController,message : String){
        let error = PopupDialog()
        error.delegrate = controller
        error.message = message
        error.messageLabel.sizeToFit()
        error.showDialog()
    }
    
    func logMessage(_ message: String,
                       fileName: String = #file,
                       functionName: String = #function,
                       lineNumber: Int = #line,
                       columnNumber: Int = #column) {
           
           print("### \(fileName) - \(message)")
    }

}
