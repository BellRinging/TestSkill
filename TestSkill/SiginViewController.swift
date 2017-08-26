//
//  SiginViewController.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 13/8/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import SwiftyJSON






protocol SignControllerDelegrate {
    func successLogin()
}

class SiginViewController: UIViewController   {
    
    
    
    weak var delegrate :LoginController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addDefaultGradient()
        setupView()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func setupView(){
        view.addSubview(stackView)
        stackView.Anchor(top: view.topAnchor, left: view.leftAnchor , right: view.rightAnchor, bottom: nil, topPadding: 18   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        stackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        view.addSubview(normalSignInButton)
        normalSignInButton.Anchor(top: stackView.bottomAnchor, left: view.leftAnchor , right: view.rightAnchor, bottom: nil, topPadding: 8   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
        view.addSubview(joinNowButton)
        joinNowButton.Anchor(top: normalSignInButton.bottomAnchor, left: nil , right: view.rightAnchor, bottom: nil, topPadding: 8   , leftPadding: 0, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        
        view.addSubview(forgetPasswordButton)
        forgetPasswordButton.Anchor(top: normalSignInButton.bottomAnchor, left: view.leftAnchor , right: nil, bottom: nil, topPadding: 8   , leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        
        view.addSubview(signInButton)
        signInButton.Anchor(top: forgetPasswordButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        
        
        let button = LoginButton(readPermissions: [ .publicProfile ,.email ])
        
        view.addSubview(button)
        button.Anchor(top: signInButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        
        button.delegate = self
    }
    
    let myActivityIndicator : UIActivityIndicatorView = {
        let im = UIActivityIndicatorView()
        return im
    }()
    
    lazy var stackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.addArrangedSubview(self.crossImageView)
        sv.addArrangedSubview(self.emailField)
        sv.addArrangedSubview(self.passwordField)
        return sv
    }()
    
    
    let crossImageView : UIView = {
        let temp = UIView()
        let ig = UIButton()
        ig.setImage(#imageLiteral(resourceName: "cancel_shadow"), for: .normal)
        temp.addSubview(ig)
        ig.Anchor(top: temp.topAnchor, left: nil, right: temp.rightAnchor, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0  )
        ig.addTarget(self, action: #selector(handleTapCross), for: .touchUpInside)
        
        return temp
    }()
    
    func handleTapCross(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    let signInButton : GIDSignInButton = {
        let bn = GIDSignInButton()
        return bn
    }()
    
    let emailField : FloatLabelTextField = {
        let tv = FloatLabelTextField()
        tv.fakePlaceholder = "Email"
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.backgroundColor = UIColor.white
        tv.rightViewMode = UITextFieldViewMode.never
        tv.addBottomBorder(UIColor.gray, thickness: 0.5)
        return tv
    }()
    
    
    let passwordField : FloatLabelTextField = {
        let tv = FloatLabelTextField()
        tv.fakePlaceholder = "Password"
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.isSecureTextEntry = true
        tv.backgroundColor = UIColor.white
        tv.rightViewMode = .whileEditing
        tv.rightView = tv.rightButton
        return tv
    }()
    

    let forgetPasswordButton : UIButton = {
        let bn = UIButton()
        let text = NSAttributedString(string: "Forget the Password", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white])
        bn.setAttributedTitle(text, for: .normal)
        bn.addTarget(self, action: #selector(handleForgetPassword), for: .touchUpInside)
        return bn
    }()
    
    func handleForgetPassword(){
        print("forgetpassword")
    }
    
    func handleJoinNow(){
        print("Join Now")
        self.dismiss(animated: true, completion: nil)
        delegrate?.handleRegister()
    }


    
    let joinNowButton : UIButton = {
        let bn = UIButton()
        let text = NSAttributedString(string: "Join Now", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white])
        bn.setAttributedTitle(text, for: .normal)
        bn.addTarget(self, action: #selector(handleJoinNow), for: .touchUpInside)
        return bn
    }()
    
    let normalSignInButton : UIButton = {
        let bn = UIButton()
        let text = NSAttributedString(string: "Sign In", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white])
        bn.setAttributedTitle(text, for: .normal)
        bn.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        bn.layer.borderWidth = 0.5
        bn.layer.borderColor = UIColor.white.cgColor
        return bn
    }()
    
    
    func handleRegister(){
//        print("Register")
        let error = PopupDialog()
        error.message = "Name is notok "
        error.delegrate = self
        error.showDialog()
        
    }
    
//    fileprivate func observeKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
//    }
//    
//    func keyboardHide() {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            print("keyboard Hide")
////            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//            
//        }, completion: nil)
//    }
//    
//    func keyboardShow() {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            print("keyboard Show")
////            let y: CGFloat = UIDevice.current.orientation.isLandscape ? 0 : 0
////            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
//            
//        }, completion: nil)
//    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

 
    
 

    
  

}
