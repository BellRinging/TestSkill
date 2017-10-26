//
//  CommentViewControlerCell.swift
//  SnookerGambling
//
//  Created by Kwok Wai Yeung on 11/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit

class CommentViewControllerCell: UICollectionViewCell {
    
    var comment:Comment?{
        didSet{
            guard let nameText = comment?.user.name else {return}
            guard let url = comment?.user.profileImageUrl else {return}
            guard let commentText = comment?.comment else {return}
            //            print(commentText)
            profileImage.loadImage(urlString: url)
            guard let timeAgo = comment?.creationDate else {return}
            setupDisplayText(name: nameText, comment: commentText ,timeAgo: timeAgo.timeAgoDisplay())
        }
    }
    
    
    let profileImage : CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40 / 2
        return imageView
    }()
    
    let username : UILabel = {
        let label = UILabel()
        //        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        //        label.backgroundColor = UIColor.red
        return label
    }()
    
    func setupDisplayText(name:String,comment :String ,timeAgo : String){
        let text = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        text.append(NSAttributedString(string: " \(comment)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)]))
        text.append(NSAttributedString(string: "\n \(timeAgo)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 10),NSForegroundColorAttributeName:UIColor.gray]))
        
        username.attributedText = text
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
        
    }
    
    func setupViewLayout(){
        
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        addSubview(username)
        username.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

