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
            setupEditFollowButton()
            updateFollowing()
            updateFollower()
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
      
    }
    
    fileprivate func setupFollowStyle() {
    
        self.editProfitAndFollow.setTitle("Follow", for: .normal)
        self.editProfitAndFollow.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfitAndFollow.setTitleColor(.white, for: .normal)
        self.editProfitAndFollow.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor

    }
    
    fileprivate func setupUnFollowStyle() {
        self.editProfitAndFollow.backgroundColor = UIColor.rgb(red: 170, green: 54, blue: 54)
        self.editProfitAndFollow.setTitleColor(.white, for: .normal)
        self.editProfitAndFollow.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        self.editProfitAndFollow.setTitle("Unfollow", for: .normal)
    }
    
    
    func removeFollowing(from: String, to: String){
        Database.database().reference().child("following").child(from).child(to).removeValue { (err, ref) in
            if let err = err {
                print("Failed to add following record", err)
                return
            }
            Database.database().reference().child("follower").child(to).child(from).removeValue { (err, ref) in
                if let err = err {
                    print("Failed to add follower record:", err)
                    return
                }
                print("Successfully Unfollowed user: ", self.user?.name ?? "")
                self.updateFollowing()
                self.setupFollowStyle()
            }
        }
    }
    
    func addFollowing(from: String, to: String){
        let ref = Database.database().reference().child("following").child(from)
        let values = [to: 1]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to add following record:", err)
                return
            }
            let ref2 = Database.database().reference().child("follower").child(to)
            let values = [from: 1]
            ref2.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to ass follower record:", err)
                    return
                }
                print("Successfully followed user: ", self.user?.name ?? "")
                self.setupUnFollowStyle()
                self.updateFollower()
            }
        }
    }
    
    func handleEditProfileOrFollow() {
        print("Execute edit profile / follow / unfollow logic...")
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.id else { return }

        
        if currentLoggedInUserId == userId {
            //edit profile
            print("Edit profile")
        } else {
            if editProfitAndFollow.titleLabel?.text == "Unfollow" {
                //unfollow
                self.removeFollowing(from: currentLoggedInUserId, to: userId)
            } else {
                //follow
                self.addFollowing(from: currentLoggedInUserId, to: userId)
            }
        }
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
        updateFollower()
        updateFollowing()
        
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
    
    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.id else { return }
        
        if currentLoggedInUserId == userId {
            //edit profile
        } else {
            
            // check if following
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.setupUnFollowStyle()
                } else {
                    self.setupFollowStyle()
                }
                
            }, withCancel: { (err) in
                print("Failed to check if following:", err)
            })
        }
    }
    
    
    lazy var editProfitAndFollow : UIButton = {
     let bn = UIButton()
        bn.setTitle("Edit Profile", for: .normal)
        bn.tintColor = UIColor.black
        bn.setTitleColor(UIColor.black, for: .normal)
        bn.layer.borderWidth = 1
        bn.layer.cornerRadius = 3
        bn.layer.borderColor = UIColor.gray.cgColor
        bn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bn.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
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
    

    let followerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    func updateFollowing(){
    
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
//        guard let userId = user?.id else { return }
    
        Database.database().reference().child("following").child(currentLoggedInUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any] {
                self.updateFollowing(dict.count)
            }else {
                    self.updateFollowing(0)
            }
        }
        , withCancel: { (err) in
            print("Failed to check if following:", err)
        })
    }
    
    func updateFollower(){
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
//        guard let userId = user?.id else { return }
        
        Database.database().reference().child("follower").child(currentLoggedInUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any] {
                self.updateFollower(dict.count)
            }else{
                self.updateFollower(0)
            }
        }
            , withCancel: { (err) in
                print("Failed to check if follower:", err)
        })
    }
    
    func updateFollowing(_ num :Int ){
        let attributedText = NSMutableAttributedString(string: "\(num)\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName : UIFont.systemFont(ofSize: 14)]))
        followingLabel.attributedText = attributedText
    }
    
    func updateFollower(_ num :Int ){
        print("update follower")
        let attributedText = NSMutableAttributedString(string: "\(num)\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Follower", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName : UIFont.systemFont(ofSize: 14)]))
            followerLabel.attributedText = attributedText
    }
    
    
    
    let followingLabel: UILabel = {
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
        let text = NSMutableAttributedString(string: "\(count)\n", attributes:[NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        text.append(NSAttributedString(string: "like", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.gray]))
        likeLabel.attributedText = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
