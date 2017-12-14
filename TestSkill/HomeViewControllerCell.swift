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
    func didTagImage(for cell: HomeViewControllerCell)
    func didShare(for cell: HomeViewControllerCell)
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
            mainImage.loadImage(url)
            nameLabel.text = name
            guard let picUrl = post?.user.imageUrl else {return }
            profileImage.loadImage(picUrl)
            setupAttributedCaption()
            guard let like =  post?.hasliked else { return }
//            print("Caption : \(post?.caption) has like \(like)")
            if like == true {
                likeButton.setImage(#imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal), for: .normal)
            }else {
                likeButton.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
            }
            guard let likeCount =  post?.likeCount else { return }
            likelabel.text = "\(likeCount) likes"
            
            timeLabel.text = post?.creationDate.timeAgoDisplay()
            
        }
    }
    
    func setupViewLayout(){
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        //header part
        addSubview(profileImage)
        profileImage.Anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 40, height: 40)
//
        addSubview(stackView)
        stackView.Anchor(top: nil, left: profileImage.rightAnchor, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        stackView.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
//
        addSubview(mainImage)
        mainImage.Anchor(top: profileImage.bottomAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: self.frame.width, height: self.frame.width)
//
        addSubview(likeButton)
        likeButton.Anchor(top: mainImage.bottomAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 30, height: 30)

        addSubview(commentButton)
        commentButton.Anchor(top: mainImage.bottomAnchor, left: likeButton.rightAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 30, height: 30)

        addSubview(bookmarkButton)
        bookmarkButton.Anchor(top: mainImage.bottomAnchor, left: nil, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 0, rightPadding: 8, bottomPadding: 0, width: 30, height: 30)

        addSubview(shareButton)
        shareButton.Anchor(top: mainImage.bottomAnchor, left: commentButton.rightAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 30, height: 30)
//
        addSubview(likelabel)
        likelabel.Anchor(top: likeButton.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
//
//        //
        addSubview(bottomlabel)
////
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
    
    func didTagImage(){
        
    }
    
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post  else { return }
        
        let temp = NSMutableAttributedString(string: "\(post.user.name)", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        
        temp.append(NSAttributedString(string: " \(post.caption)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.black]))
        
        temp.append(NSAttributedString(string: "\n #funny #abc #noob\n", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.blue]))
        
        temp.append(NSAttributedString(string: "View All 3 comments", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.gray]))
        
        bottomlabel.attributedText = temp
        bottomlabel.sizeToFit()
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
    
    

    
    lazy var stackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.backgroundColor = UIColor.red
        sv.addArrangedSubview(self.nameLabel)
        sv.addArrangedSubview(self.timeLabel)
        return sv
    }()
    
    
    func handleLike(){
        //        print("Like")
        delegate?.didLike(for: self)
    }
    
    func handleComment(){
        delegate?.didTapComment(post: post!)
    }
    
    
    func handleTagImage(){
        print("Tag Image")
        delegate?.didTagImage(for: self)
    }
    
    func handleBookmark(){
        print("bookmark")
    }
    
    func handleShare(){
        delegate?.didShare(for: self)
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
    
    let timeLabel : UILabel = {
        let lb = UILabel()
        lb.text = "name"
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor.gray
        return lb
    }()
    
    lazy var mainImage : CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTagImage)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        print(layoutAttributes.size)
//        setNeedsLayout()
//        layoutIfNeeded()
        if let post = post{
            var height = 8 + 40 + 8 + UIScreen.main.bounds.width + 8 + 40 + 8
            height = height + calculatTextHeigh(post: post)
            var newFrame = layoutAttributes.frame
            newFrame.size.height = height
            layoutAttributes.frame = newFrame
        }
        
        return layoutAttributes
    }
    
    fileprivate func calculatTextHeigh(post : Post) -> CGFloat {
        
        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
        let estimatedSize = bottomlabel.systemLayoutSizeFitting(targetSize)
//        print("estimatedSize",estimatedSize.height)
        return estimatedSize.height
    }
    
  
    
    
}

