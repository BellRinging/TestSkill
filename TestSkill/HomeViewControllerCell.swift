//
//  HomeViewControllerCell.swift
//  SnookerGambling
//
//  Created by Kwok Wai Yeung on 6/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit


protocol HomePostCellDelegate {
    func didTapComment(post: Post)
    func didLike(for cell: HomeViewControllerCell)
}

class HomeViewControllerCell: UICollectionViewCell {
    
    
    var delegate: HomePostCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var post : Post? {
        didSet{
            guard let name = post?.user.name ,let url = post?.imageUrl  else {return }
            mainImage.loadImage(urlString: url)
            nameLabel.text = name
            guard let picUrl = post?.user.profileImageUrl else {return }
            profileImage.loadImage(urlString: picUrl)
            setupAttributedCaption()
            guard let like =  post?.hasLiked else { return }
            //            print("Caption : \(post?.caption) has like \(like)")
            if like == true {
                likeButton.setImage(#imageLiteral(resourceName: "redHeart.svg").withRenderingMode(.alwaysOriginal), for: .normal)
            }else {
                likeButton.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
            }
            guard let likeCount =  post?.likeCount else { return }
            likelabel.text = "\(likeCount) likes"
            
        }
    }
    
    func setupViewLayout(){
        
        //header part
        addSubview(profileImage)
        profileImage.Anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 40, height: 40)
        
        addSubview(nameLabel)
        nameLabel.Anchor(top: nil, left: profileImage.rightAnchor, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        
        nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        addSubview(mainImage)
        mainImage.Anchor(top: profileImage.bottomAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: self.frame.width, height: self.frame.width)
        
        addSubview(likeButton)
        likeButton.Anchor(top: mainImage.bottomAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 20, height: 20)
        
        addSubview(commentButton)
        commentButton.Anchor(top: mainImage.bottomAnchor, left: likeButton.rightAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 20, height: 20)
        
        addSubview(bookmarkButton)
        bookmarkButton.Anchor(top: mainImage.bottomAnchor, left: nil, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 0, rightPadding: 8, bottomPadding: 0, width: 20, height: 20)
        
        addSubview(shareButton)
        shareButton.Anchor(top: mainImage.bottomAnchor, left: commentButton.rightAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 20, height: 20)
        
        addSubview(likelabel)
        likelabel.Anchor(top: likeButton.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        
        //
        addSubview(bottomlabel)

        bottomlabel.Anchor(top: likelabel.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        
        
        
    }
    
    lazy var likeButton : UIButton = {
        let bn = UIButton(type: .system)
        bn.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        bn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bn.tintColor = UIColor.blue
        return bn
    }()
    
    let likelabel : UILabel = {
        let lb = UILabel()
        //        lb.text = "11 likes"
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        return lb
    }()
    
    let bottomlabel : UILabel = {
        let lb = UILabel()
        
        lb.numberOfLines = 0
        return lb
    }()
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post ,let username = post.user.name  else { return }
        
        
        let temp = NSMutableAttributedString(string: "\(username)", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        
        temp.append(NSAttributedString(string: " \(post.caption)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.black]))
        
        temp.append(NSAttributedString(string: "\n #funny #abc #noob\n", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.blue]))
        
        temp.append(NSAttributedString(string: "View All 3 comments", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.gray]))
        
        
        temp.append(NSAttributedString(string: "\n\(post.creationDate.timeAgoDisplay())" , attributes:[NSFontAttributeName: UIFont.systemFont(ofSize: 10) ,NSForegroundColorAttributeName:UIColor.gray]))
        
        bottomlabel.attributedText = temp
    }
    
    
    
    lazy var commentButton : UIButton = {
        let bn = UIButton(type: .system)
        bn.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        bn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        bn.tintColor = UIColor.blue
        return bn
    }()
    
    lazy var bookmarkButton : UIButton = {
        let bn = UIButton(type: .system)
        bn.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        bn.addTarget(self, action: #selector(handleBookmark), for: .touchUpInside)
        bn.tintColor = UIColor.blue
        return bn
    }()
    
    lazy var shareButton : UIButton = {
        let bn = UIButton(type: .system)
        bn.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        bn.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        bn.tintColor = UIColor.blue
        return bn
    }()
    
    
    let stackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.backgroundColor = UIColor.red
        return sv
    }()
    
    
    
    func handleLike(){
        //        print("Like")
        delegate?.didLike(for: self)
    }
    
    func handleComment(){
        delegate?.didTapComment(post: post!)
    }
    
    
    func handleBookmark(){
        print("bookmark")
    }
    
    func handleShare(){
        print("Share")
    }
    
    let profileImage : CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal)
        imageView.layer.cornerRadius = 40/2
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let lb = UILabel()
        lb.text = "name"
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        return lb
    }()
    
    let mainImage : CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    
    
}

