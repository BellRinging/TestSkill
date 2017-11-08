//
//  ProfileHeaderViewCell.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import Firebase

class ProfileHeaderCell: UICollectionViewCell {
    
    
    var user : User? {
        didSet{
            guard let url = user?.imageUrl else {return}
            profileImage.loadImage(url)
            guard let name = user?.name else {return}
            nameLabel.text = name
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
      
    }
    
    func setupView(){
        addSubview(profileImage)
        addSubview(editProfitAndFollow)
        addSubview(topStackView)
        
        topStackView.addArrangedSubview(followerLabel)
        topStackView.addArrangedSubview(followingLabel)
        topStackView.addArrangedSubview(likeLabel)
        addSubview(bottomStackView)
        addSubview(nameLabel)
        
        
        bottomStackView.addArrangedSubview(listButton)
        bottomStackView.addArrangedSubview(GirdButton)
        bottomStackView.addArrangedSubview(bookmarkButton)
        
        setlikeCount(5)
        setFollowerCount(7)
        setFollowingCount(10)
        
        profileImage.Anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 80, height: 80)
        topStackView.Anchor(top: topAnchor, left: profileImage.rightAnchor, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        bottomStackView.Anchor(top: nil, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 30)
        editProfitAndFollow.Anchor(top: topStackView.bottomAnchor, left: profileImage.rightAnchor, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 30)
        
        let dummy = UIView()
        dummy.backgroundColor = UIColor.gray
        addSubview(dummy)
        dummy.Anchor(top: bottomStackView.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0.5)
        
        let dummy2 = UIView()
        dummy2.backgroundColor = UIColor.gray
        addSubview(dummy2)
        dummy2.Anchor(top: nil, left: leftAnchor, right: rightAnchor, bottom: bottomStackView.topAnchor, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0.5)
        
        nameLabel.Anchor(top: profileImage.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
    }
    
    
    let topStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
//        sv.tintColor = UIColor.brown
        return sv
    }()
    
    
    let bottomStackView : UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.tintColor = UIColor.brown
        return sv
    }()
    
    let profileImage : CustomImageView = {
        let im = CustomImageView()
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        im.image = #imageLiteral(resourceName: "empty-avatar")
        im.layer.cornerRadius = 80/2
        return im
    }()
    
    
    let editProfitAndFollow : UIButton = {
     let bn = UIButton()
        bn.setTitle("Edit Profile", for: .normal)
        bn.tintColor = UIColor.black
        bn.setTitleColor(UIColor.black, for: .normal)
        bn.layer.borderWidth = 1
        bn.layer.cornerRadius = 3
        bn.layer.borderColor = UIColor.gray.cgColor
        return bn
    }()
    
    let listButton : UIButton = {
        let bn = UIButton()
        bn.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        return bn
    }()
    
    
    let GirdButton : UIButton = {
        let bn = UIButton()
        bn.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return bn
    }()
    
    let bookmarkButton : UIButton = {
        let bn = UIButton()
        bn.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        return bn
    }()
    
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Chan Kenny"
        return label
    }()
    
    let followingLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let followerLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let likeLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    func setlikeCount( _ count : Int){
        let text = NSMutableAttributedString(string: "\(count)\n", attributes:[NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.gray])
        text.append(NSAttributedString(string: "like", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)]))
        likeLabel.attributedText = text
    }
    
    func setFollowerCount( _ count : Int){
        let text = NSMutableAttributedString(string: "\(count)\n", attributes:[NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.gray])
        text.append(NSAttributedString(string: "Follower", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)]))
        followerLabel.attributedText = text
    }
    
  
    
    func setFollowingCount( _ count : Int){
        let text = NSMutableAttributedString(string: "\(count)\n", attributes:[NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.gray])
        text.append(NSAttributedString(string: "Following", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)]))
        followingLabel.attributedText = text
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
