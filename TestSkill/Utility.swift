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
        guard let mainWindow = UIApplication.shared.delegate?.window else { return }
        let progressIcon = MBProgressHUD.showAdded(to: mainWindow!, animated: true)
        progressIcon.labelText = "Loading"
        progressIcon.isUserInteractionEnabled = false
        //tempView
        
        let tempView = UIView(frame: (mainWindow?.frame)!)
        tempView.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        tempView.tag = 999
        mainWindow?.addSubview(tempView)
        progressIcon.show(animated: true)
    }
    
    static func hideProgress(){
        guard let mainWindow = UIApplication.shared.delegate?.window else { return }
        MBProgressHUD.hideAllHUDs(for: mainWindow!, animated: true)
        let view = mainWindow?.viewWithTag(999)
        view?.removeFromSuperview()
    }
    

}
