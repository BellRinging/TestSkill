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
        firstNameField.Anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 30, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 60)
        
        
//        let fld = FloatLabelTextField(frame:vwHolder.bounds)
//        fld.placeholder = "Comments"
    }
    
    
    let firstNameField : FloatLabelTextField = {
        let tv = FloatLabelTextField()
        tv.attributedPlaceholder = NSAttributedString(string: "Frist Name", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 25)])
        tv.spellCheckingType = .no
        tv.autocorrectionType = .no
        tv.backgroundColor = UIColor.white
        tv.titleTextColour = UIColor.black
        tv.titleActiveTextColour = UIColor.black
        tv.addBottomBorder(UIColor.gray, thickness: 0.5)
        tv.clearButtonMode = UITextFieldViewMode.always
        return tv
    }()
    
    
    
    
}
