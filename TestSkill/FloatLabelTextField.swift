//
//  FloatLabelTextField.swift
//  FloatLabelFields
//
//  Created by Fahim Farook on 28/11/14.
//  Copyright (c) 2014 RookSoft Ltd. All rights reserved.
//
//  Original Concept by Matt D. Smith
//  http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?list=users
//
//  Objective-C version by Jared Verdi
//  https://github.com/jverdi/JVFloatLabeledTextField
//

import UIKit

@IBDesignable class FloatLabelTextField: UITextField {
	let animationDuration = 0.3
	var title = UILabel()
    var isShowingTitle : Bool = false
    var placeHolderYPostion : CGFloat = 0.0
    
    
    let leftPadding : UIView = {
        let paddingView = UIView()
//        paddingView.backgroundColor = UIColor.red
        paddingView.frame = CGRect(x: 0, y: 0, width: 10.0, height: 20)
        return paddingView
    }()
    
	
    let rightButton : UIButton = {
        let paddingView = UIButton(type: .system)
        paddingView.setTitle("Show ", for: .normal)
        paddingView.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
        paddingView.sizeToFit()
        return paddingView
    }()
    
    func handleSwitch(){
        
        
        if rightButton.titleLabel?.text == "Show " {
            self.isSecureTextEntry = false
            rightButton.setTitle("Hide ", for: .normal)
            rightButton.sizeToFit()
        }else {
            self.isSecureTextEntry = true
            rightButton.setTitle("Show ", for: .normal)
            rightButton.sizeToFit()
        }
    }
    
    
	// MARK:- Properties
	override var accessibilityLabel:String? {
		get {
			if let txt = text , txt.isEmpty {

				return title.text
			} else {
				return text
			}
		}
		set {
			self.accessibilityLabel = newValue
		}
	}
	

   var fakePlaceholder:String? {
        didSet {
            title.text = fakePlaceholder
        }
    }
	
	var titleFont:UIFont = UIFont.boldSystemFont(ofSize: 14){
		didSet {
			title.font = titleFont
			title.sizeToFit()
		}
	}
	
	@IBInspectable var hintYPadding:CGFloat = 0.0

	@IBInspectable var titleYPadding:CGFloat = 8.0 {
		didSet {
			var r = title.frame
			r.origin.y = titleYPadding
			title.frame = r
		}
	}
	
	@IBInspectable var titleTextColour:UIColor = UIColor.gray {
		didSet {
            title.textColor = titleTextColour
		}
	}
	
	@IBInspectable var titleActiveTextColour:UIColor! {
		didSet {
			if isFirstResponder {
				title.textColor = titleActiveTextColour
			}
		}
	}
		
	// MARK:- Init
	required init?(coder aDecoder:NSCoder) {
		super.init(coder:aDecoder)
		setup()
	}
	
	override init(frame:CGRect) {
		super.init(frame:frame)
		setup()
	}
	
	// MARK:- Overrides
	override func layoutSubviews() {
		super.layoutSubviews()
		setTitlePositionForTextAlignment()
		let isResp = isFirstResponder
		if let txt = text , !txt.isEmpty && isResp {
			title.textColor = titleActiveTextColour
		} else {
			title.textColor = titleTextColour
		}
		if let txt = text , txt.isEmpty {
			hideTitle(isResp)
		} else {
            if (!isShowingTitle){
                showTitle(isResp)
            }
			
		}
	}
	
	override func textRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.textRect(forBounds: bounds)
		if let txt = text , !txt.isEmpty {
			let top = maxTopInset()
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0, 0.0, 0.0))
		}
        
		return r.integral
	}
	
	override func editingRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.editingRect(forBounds: bounds)
		if let txt = text , !txt.isEmpty {
			let top = maxTopInset()
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0, 0.0, 0.0))
		}
		return r.integral
	}
	
	override func clearButtonRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.clearButtonRect(forBounds: bounds)
		if let txt = text , !txt.isEmpty {
			let top = maxTopInset()
			r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
		}
		return r.integral
	}
	
	fileprivate func setup() {
		borderStyle = UITextBorderStyle.none
		titleActiveTextColour = tintColor
		title.font = titleFont
		title.textColor = titleTextColour
		self.addSubview(title)
        self.leftViewMode = .always
        self.leftView = leftPadding
//        self.rightViewMode = .always
//        self.rightView = rightButton
	}

	fileprivate func maxTopInset()->CGFloat {
		if let fnt = font {
			return max(0, floor(bounds.size.height - fnt.lineHeight - 4.0 - titleYPadding))
            //4.0 is padding bottom
		}
		return 0
	}
	
	fileprivate func setTitlePositionForTextAlignment() {
		let r = textRect(forBounds: bounds)
		let x = r.origin.x
		title.frame = CGRect(x:x, y:title.frame.origin.y , width:title.frame.size.width , height:title.frame.size.height)
	}
	
	fileprivate func showTitle(_ animated:Bool) {
//        print("showTitle")
        isShowingTitle = true
        guard let font2 = self.font else {return}
        self.titleFont = font2
        let posY = (self.bounds.height - font2.lineHeight) / 2 - titleYPadding
        var r = self.textRect(forBounds: self.bounds)
        r.origin.y = posY
        titleTextColour = UIColor.gray
        title.frame = r
        
		let dur = animated ? animationDuration : 0
		UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveLinear], animations:{
				var r = self.textRect(forBounds: self.bounds)
				r.origin.y = self.titleYPadding
				self.title.frame = r
            self.titleFont = UIFont.boldSystemFont(ofSize: 12)
            self.titleTextColour = UIColor.black
			}, completion:nil)
	}
	
	fileprivate func hideTitle(_ animated:Bool) {
//        print("hideTitle")
        isShowingTitle = false
        guard let font2 = self.font else {
            return
        }
		let dur = animated ? animationDuration : 0
		UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveLinear], animations:{
            self.titleFont = font2
            self.titleTextColour = UIColor.gray
            let r = self.textRect(forBounds: self.bounds)
			self.title.frame = r
        }, completion: nil)
	}
}
