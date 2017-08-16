//
//  TestGoogle.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 16/8/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit

class TestGoogle: UIViewController ,GIDSignInUIDelegate{
    
    let myActivityIndicator : UIActivityIndicatorView = {
        let im = UIActivityIndicatorView()
        return im
    }()
    let signInButton : GIDSignInButton = {
        let bn = GIDSignInButton()
        return bn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        GIDSignIn.sharedInstance().uiDelegate = self
//        view.addSubview(signInButton)
        setupGoogleButtons()
        
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
         myActivityIndicator.stopAnimating()
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
            self.present(viewController, animated: true, completion: nil)
    }
    
    
    
    fileprivate func setupGoogleButtons() {
        //add google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 16, y: 116 + 66 + 66, width: view.frame.width - 32, height: 50)
        customButton.backgroundColor = .orange
        customButton.setTitle("Custom Google Sign In", for: .normal)
        customButton.addTarget(self, action: #selector(handleCustomGoogleSign), for: .touchUpInside)
        customButton.setTitleColor(.white, for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        view.addSubview(customButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func handleCustomGoogleSign() {
        GIDSignIn.sharedInstance().signIn()
    }
}
