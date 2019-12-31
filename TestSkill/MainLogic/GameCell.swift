//
//  ProfileHeaderViewCell.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    var game : Game? {
        didSet{
//            guard let url = post?.imageUrl else {return}
            gameDateLabel.text = game?.date
//            creditValueLabel.text = game?.game_id
//            image.loadImage(url)
        }
    }
    
    
    let gameDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let creditValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    

    func setupView(){
        addSubview(gameDateLabel)
        gameDateLabel.Anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: self.frame.width, height: 50)
//
//        addSubview(creditValueLabel)
//        (creditValueLabel).Anchor(top: gameDateLabel.bottomAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: self.frame.width, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
