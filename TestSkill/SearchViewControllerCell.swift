//
//  SearchViewControllerCell.swift
//  SnookerGambling
//
//  Created by Kwok Wai Yeung on 1/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import Foundation

class SearchViewControllerCell: UICollectionViewCell {
    
    
    var user : User?{
        didSet{
            username.text = user?.name
            guard let urlString = user?.imageUrl else {return}
            profileImage.loadImage(urlString)
        }
    }
    
    let profileImage : CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60 / 2
        return imageView
    }()
    
    let username : UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImage)
        
        profileImage.Anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 60, height: 60)
        
        addSubview(username)
        
        username.Anchor(top: topAnchor, left: profileImage.rightAnchor, right: rightAnchor, bottom: bottomAnchor, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.Anchor(top: nil, left: username.leftAnchor, right: rightAnchor, bottom: bottomAnchor, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0.5)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

