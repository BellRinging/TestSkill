//
//  SiginViewController.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 13/8/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import FirebaseAuth
import MBProgressHUD



class RegisterViewController: UIViewController {
    
    
    
    
    var errorMessage = ""
    weak var delegrate :LoginController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addDefaultGradient()
        setupView()
        
    }
    
    var progressIcon : MBProgressHUD?
    
    func setupView(){
        view.addSubview(stackView)
        stackView.Anchor(top: view.topAnchor, left: view.leftAnchor , right: view.rightAnchor, bottom: nil, topPadding: 18   , leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        stackView.heightAnchor.constraint(equalToConstant: 350).isActive = true
    }
    
    lazy var stackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.addArrangedSubview(self.crossImageView)
        sv.addArrangedSubview(self.userNameField)
//        sv.addArrangedSubview(self.lastNameField)
        sv.addArrangedSubview(self.emailField)
        sv.addArrangedSubview(self.passwordField)
        sv.addArrangedSubview(self.warrentLabel)
        sv.addArrangedSubview(self.registerButton)
        sv.addArrangedSubview(self.bottomStackView)
        sv.backgroundColor = UIColor.red
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
    
    
    let userNameField : FloatLabelTextField = {
        let tv = FloatLabelTextField()
        tv.fakePlaceholder = "User Name"
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.backgroundColor = UIColor.white
        tv.addBottomBorder(UIColor.gray, thickness: 0.5)
        return tv
    }()
    
    let emailField : FloatLabelTextField = {
        let tv = FloatLabelTextField()
        tv.fakePlaceholder = "Email"
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.backgroundColor = UIColor.white
        tv.addBottomBorder(UIColor.gray, thickness: 0.5)
        return tv
    }()
    
    
    let passwordField : FloatLabelTextField = {
        let tv = FloatLabelTextField()
        tv.fakePlaceholder = "Password"
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.isSecureTextEntry = true
//        self.rightViewMode = .always
        tv.rightView = tv.rightButton
        tv.rightViewMode = .whileEditing
        tv.backgroundColor = UIColor.white
        return tv
    }()
    
    let warrentLabel : UILabel = {
        let lb = UILabel()
        lb.text = "By Clicking Join Now , you agree to Linkin User Agreement \nPrivary Policy and Cookie Policy"
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.numberOfLines = 2
        lb.textColor = UIColor.textColor()
        return lb
    }()
    
    lazy var bottomStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.addArrangedSubview(self.siginLabel)
        sv.addArrangedSubview(self.signInButton)
        return sv
    }()
    
    
    let siginLabel : UILabel = {
        let lb = UILabel()
        lb.text = "Already have an account?"
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textAlignment = .center
        lb.textColor = UIColor.textColor()
        return lb
    }()
    
    let signInButton : UIButton = {
        let bn = UIButton()
        let text = NSAttributedString(string: "Sign In", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.white])
        bn.setAttributedTitle(text, for: .normal)
        bn.addTarget(self, action: #selector(handleSwitchSignIn), for: .touchUpInside)
        return bn
    }()
    
    func handleSwitchSignIn(){
        print("handle Switch to login")
        self.dismiss(animated: true, completion: nil)
        delegrate?.handleLogin()
    }
    
    
    let registerButton : UIButton = {
        let bn = UIButton()
        let text = NSAttributedString(string: "Join Now", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white])
        bn.setAttributedTitle(text, for: .normal)
        bn.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        bn.layer.borderWidth = 0.5
        bn.layer.borderColor = UIColor.white.cgColor
        return bn
    }()
    
    
    func lockTextField(){
        userNameField.isEnabled = false
        emailField.isEnabled = false
        passwordField.isEnabled = false
        signInButton.isEnabled = false
        
    }

    func unlockTextField(){
        userNameField.isEnabled = true
        emailField.isEnabled = true
        passwordField.isEnabled = true
        signInButton.isEnabled = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func showError(message : String){
        let error = PopupDialog()
        error.delegrate = self
        error.message = message
        error.messageLabel.sizeToFit()
        error.showDialog()
    }
}
