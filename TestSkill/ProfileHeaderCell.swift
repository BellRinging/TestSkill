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
            guard let url = user?.img_url else {return}
            profileImage.loadImage(url)
            guard let name = user?.user_name else {return}
            nameLabel.text = name
            updateCount(area: DisplayArea.follower)
            updateCount(area: DisplayArea.following)
            updateButtonStatus()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        //Default Value
        updateCount(area: DisplayArea.like)
        updateCount(area: DisplayArea.follower)
        updateCount(area: DisplayArea.following)
        
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
    
    func removeFollowing(from: String, to: String){
        Utility.showProgress()
        Database.database().reference().child("following").child(from).child(to).removeValue { (err, ref) in
            if let err = err {
                print("Failed to add following record", err)
                Utility.hideProgress()
                return
            }
            Database.database().reference().child("follower").child(to).child(from).removeValue { (err, ref) in
                if let err = err {
                    print("Failed to add follower record:", err)
                    Utility.hideProgress()
                    return
                }
                print("Successfully Unfollowed user: ", self.user?.user_name ?? "")
                self.setupButtonStyle(following: false)
                self.updateCount(area: DisplayArea.follower)
                Utility.hideProgress()
            }
        }
    }
    
    func addFollowing(from: String, to: String){
        
        Utility.showProgress()
        let ref = Database.database().reference().child("following").child(from)
        let values = [to: 1]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to add following record:", err)
                Utility.hideProgress()
                return
            }
            let ref2 = Database.database().reference().child("follower").child(to)
            let values = [from: 1]
            ref2.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to ass follower record:", err)
                    Utility.hideProgress()
                    return
                }
                print("Successfully followed user: ", self.user?.user_name ?? "")
                self.setupButtonStyle(following: true)
                self.updateCount(area: DisplayArea.follower)
                Utility.hideProgress()
            }
        }
    }
    
    @objc func handleEditProfileOrFollow() {
        print("Execute edit profile / follow / unfollow logic...")
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.user_id else { return }
        if currentLoggedInUserId == userId {
            //edit profile
            self.handleEditProfile()
        } else {
            self.handleFollowUnFollow(from: currentLoggedInUserId, to: userId)
        }
    }
    
    fileprivate func handleEditProfile(){
        print("Edit profile")
    }
    
    func handleFollowUnFollow(from : String , to : String){
        if editProfitAndFollow.titleLabel?.text == "Unfollow" {
            //unfollow
            self.removeFollowing(from: from, to: to)
        } else {
            //follow
            self.addFollowing(from: from, to: to)
        }
    }
    
    fileprivate func setupButtonStyle(following : Bool) {
        if !following {
            //setup to following
            self.editProfitAndFollow.setTitle("Follow", for: .normal)
            self.editProfitAndFollow.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            self.editProfitAndFollow.setTitleColor(.white, for: .normal)
            self.editProfitAndFollow.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        }else {
            self.editProfitAndFollow.backgroundColor = UIColor.rgb(red: 170, green: 54, blue: 54)
            self.editProfitAndFollow.setTitleColor(.white, for: .normal)
            self.editProfitAndFollow.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
            self.editProfitAndFollow.setTitle("Unfollow", for: .normal)
        }
    }

    
    func updateButtonStatus(){
        print("Update Button status")
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.user_id else { return }
        print(userId)
        if(currentLoggedInUserId == userId) {
            //do nothing 
        }else {
            Utility.showProgress()
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                self.setupButtonStyle(following: snapshot.exists())
                Utility.hideProgress()
            }
                , withCancel: { (err) in
                    print("Failed to check the button status", err)
            })
        }
        
       
    }
    
    func updateCount(area:DisplayArea){
        print("Update Count for \(area)")
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        var id = currentLoggedInUserId
        if let userId = user?.user_id , userId != currentLoggedInUserId {
            id = userId
        }
        Utility.showProgress()
        Database.database().reference().child("\(area)").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any] {
                self.setCount(dict.count, area: area)
            }else{
                self.setCount(0, area: area)
            }
            Utility.hideProgress()
        }
        , withCancel: { (err) in
                print("Failed to check area \(area):", err)
        })
    }
    
    func setCount(_ count:Int , area : DisplayArea){
        print("Set count for \(area) : \(count)")
        let attributedText = NSMutableAttributedString(string: "\(count)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "\(area)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        if area == DisplayArea.follower {
            followerLabel.attributedText = attributedText
        }else if(area == DisplayArea.following){
            followingLabel.attributedText = attributedText
        }else{
            likeLabel.attributedText = attributedText
        }
    }
    
    
    enum DisplayArea{
        case like
        case follower
        case following
    }

}


