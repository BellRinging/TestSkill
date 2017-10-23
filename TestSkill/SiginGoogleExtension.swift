//
//  SiginGoogleExtension.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 18/8/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import Foundation


extension SiginViewController : GIDSignInUIDelegate {
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        myActivityIndicator.stopAnimating()
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
  
    
}
