//
//  ProfileHeaderViewCell.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit

class LoginCell: UICollectionViewCell {
    
    var page : Page? {
        didSet{
            guard let page = page else {return }
            
            
            let attributedText = NSMutableAttributedString(string: page.title, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium), NSForegroundColorAttributeName: UIColor.textColor()])
            
            attributedText.append(NSAttributedString(string: "\n\n\(page.massage)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.textColor()]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let length = attributedText.string.characters.count
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: length))
            
            textView.attributedText = attributedText
            
            imageView.image = UIImage(named: page.image)

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor.random()
        setupView()
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.isEditable = false
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tv.backgroundColor = UIColor.clear
        return tv
    }()

    
    
    let imageView : CustomImageView = {
        let im = CustomImageView()
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        //        im.layer.cornerRadius = 60/2
        return im
    }()
    
    
    func setupView(){
        addSubview(textView)
        textView.Anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topPadding: 20, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        addSubview(imageView)
        imageView.Anchor(top: textView.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 200)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
