//
//  Helper.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 11/9/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import MBProgressHUD

class Utility {
    
    static func showProgress(){
        print("Show Progress")
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
    
    static func hideProgress(){
        print("hide Progress")
        guard let mainWindow = UIApplication.shared.delegate?.window else { return }
        MBProgressHUD.hideAllHUDs(for: mainWindow!, animated: true)
        let view = mainWindow?.viewWithTag(999)
        view?.removeFromSuperview()
    }
    
    static func showPopUpDialog(viewController:UIViewController, message : String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default)
        {
            (UIAlertAction) -> Void in
        }
        alert.addAction(alertAction)
        viewController.present(alert, animated: true)
        {
            () -> Void in
        }
    }

    

}
