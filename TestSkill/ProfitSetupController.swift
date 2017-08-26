//
//  ProfitSetupController.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 23/8/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit

class ProfileSetupController : UIViewController {
    
    var user : User? {
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addDefaultGradient()
        view.addSubview(firstNameField)
        firstNameField.Anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 30, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
        view.addSubview(passwordField)
        passwordField.Anchor(top: firstNameField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 30, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
        
        
        
//        let fld = FloatLabelTextField(frame:vwHolder.bounds)
//        fld.placeholder = "Comments"
    }
    
    
    let firstNameField : FloatLabelTextField = {
        let tv = FloatLabelTextField()
//        tv.attributedPlaceholder = NSAttributedString(string: "Frist Name", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 25)])
        tv.fakePlaceholder = "First Name"
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.backgroundColor = UIColor.white
        tv.titleTextColour = UIColor.black
        tv.titleActiveTextColour = UIColor.black
        tv.addBottomBorder(UIColor.gray, thickness: 0.5)
        tv.clearButtonMode = UITextFieldViewMode.always
   
        return tv
    }()
    
    
    let passwordField : UITextField = {
        let tv = UITextField()
        tv.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 25)])
        let leftPadding = UIView()
        leftPadding.backgroundColor = UIColor.red
        leftPadding.frame = CGRect(x: 0, y: 0, width: 10.0, height: 20)
        tv.leftView = leftPadding
        tv.leftViewMode = .always
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.backgroundColor = UIColor.white
        tv.addBottomBorder(UIColor.gray, thickness: 0.5)
        tv.clearButtonMode = UITextFieldViewMode.always
        
        
        return tv
    }()
    
    
    
    
}
