//
//  ProfileHeaderViewCell.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit

class SinglePhotoCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    let image : CustomImageView = {
       let im = CustomImageView()
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
//        im.layer.cornerRadius = 60/2
        return im
    }()
    
    func setupView(){
        addSubview(image)
        image.Anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: self.frame.width, height: self.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
