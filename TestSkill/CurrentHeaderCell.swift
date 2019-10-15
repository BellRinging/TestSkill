//
//  ProfileHeaderViewCell.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit

class CurrentHeaderCell: UICollectionViewCell {
    
    
    var group : UserGroup? {
        didSet{
          
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
    
    let backgroupImage : CustomImageView = {
        let im = CustomImageView()
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        im.image = #imageLiteral(resourceName: "empty-avatar")
        return im
    }()
    
    let AmountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "365"
        label.backgroundColor = .red
        return label
    }()
    
    let dropDownButton: UIButton = {
         let label = UIButton()
        label.setTitle("drop down", for: .normal)
        label.backgroundColor = .brown
         return label
     }()
     
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    
    func setupView(){
        
      
        addSubview(backgroupImage)
        addSubview(AmountLabel)
        addSubview(dropDownButton)
        
        
        backgroupImage.Anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        dropDownButton.Anchor(top: topAnchor, left: nil, right: nil, bottom: nil, topPadding: 8, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 100, height: 20)
        dropDownButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        AmountLabel.Anchor(top: dropDownButton.bottomAnchor, left: nil, right: nil, bottom: nil, topPadding: 8, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 100, height: 100)
        AmountLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    
}


