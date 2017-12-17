//
//  UITextViewFixed.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/12/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import Foundation


@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        
        // this is not ideal, but you can sometimes use this
        // to fix the "space at bottom" insanity
        var b = bounds
        let h = sizeThatFits(CGSize(
            width: bounds.size.width,
            height: CGFloat.greatestFiniteMagnitude)
            ).height
        b.size.height = h
        bounds = b
    }
}
