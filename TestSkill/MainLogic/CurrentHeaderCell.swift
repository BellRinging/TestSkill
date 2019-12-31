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
        label.font = UIFont.systemFont(ofSize: 36)
//        label.backgroundColor = .red
        return label
    }()
    
   let amountPaidLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "365"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    
    let player1: UIButton = {
        let bn = UIButton()
        bn.layer.cornerRadius = 25
        bn.tag = 1
        bn.setImage(#imageLiteral(resourceName: "gear"), for: .normal)
        return bn
      }()
    
    let player2: UIButton = {
      let bn = UIButton()
        bn.tag = 2
      bn.layer.cornerRadius = 25
        bn.setImage(#imageLiteral(resourceName: "gear"), for: .normal)
      return bn
    }()
    
    let player3: UIButton = {
      let bn = UIButton()
        bn.tag = 3
      bn.layer.cornerRadius = 25
      bn.setImage(#imageLiteral(resourceName: "gear"), for: .normal)
      return bn
    }()
    
    
    let player4: UIButton = {
      let bn = UIButton()
        bn.tag = 4
      bn.layer.cornerRadius = 25
      bn.setImage(#imageLiteral(resourceName: "gear"), for: .normal)
      return bn
    }()
    
    
    lazy var playerStack : UIStackView = {
           let sv = UIStackView()
           sv.axis = .horizontal
           sv.distribution = .fillEqually
           sv.spacing = 8
           sv.addArrangedSubview(player1)
           sv.addArrangedSubview(player2)
        sv.addArrangedSubview(player3)
        sv.addArrangedSubview(player4)
        sv.layer.borderWidth = 1
        sv.layer.borderColor = UIColor.black.cgColor
sv.backgroundColor = .white
           return sv
       }()
    
    
    lazy var uiForAmountStack : UIView = {
           let sv = UIView()
        sv.layer.borderColor = UIColor.gray.cgColor
        sv.layer.borderWidth = 0.5
            sv.layer.borderColor = UIColor.black.cgColor
            sv.backgroundColor = .white

           return sv
       }()
    
    
    var uiForPlayerStack : UIView = {
           let sv = UIView()
        sv.layer.borderWidth = 0.5
        sv.layer.borderColor = UIColor.gray.cgColor
            sv.layer.borderColor = UIColor.black.cgColor
            sv.backgroundColor = .white
      
           return sv
       }()

    
    lazy var amountStack : UIStackView = {
           let sv = UIStackView()
           sv.axis = .horizontal
           sv.distribution = .fillEqually
           sv.spacing = 8
           sv.addArrangedSubview(amountReceivedLabel)
           sv.addArrangedSubview(amountPaidLabel)
        sv.layer.borderWidth = 1
        sv.layer.borderColor = UIColor.black.cgColor
        sv.backgroundColor = .white

           return sv
       }()
    
    let playerlabel: UILabel = {
          let label = UILabel()
          label.numberOfLines = 0
          label.textAlignment = .center
          label.text = "3 Person \n Good People"
          label.font = UIFont.systemFont(ofSize: 12)
          return label
      }()
    
    let amountReceivedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "365\n ABC"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()

     
    
    let dropDownButton: UIButton = {
        let label = UIButton()
        label.setTitle("drop down select", for: .normal)
        label.backgroundColor = .brown
        return label
    }()
     
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    
    func setupView(){
        
      
        addSubview(backgroupImage)
        addSubview(dropDownButton)
        addSubview(AmountLabel)

       
        addSubview(uiForPlayerStack)
        addSubview(uiForAmountStack)
        
        
        backgroupImage.Anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        dropDownButton.Anchor(top: topAnchor, left: nil, right: nil, bottom: nil, topPadding: 8, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 100, height: 30)
        dropDownButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        AmountLabel.Anchor(top: dropDownButton.bottomAnchor, left: nil, right: nil, bottom: nil, topPadding: 8, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 100, height: 100)
        AmountLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        uiForPlayerStack.Anchor(top: AmountLabel.bottomAnchor, left: leftAnchor , right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 50)
        uiForPlayerStack.addSubview(playerlabel)
        playerlabel.Anchor(top: uiForPlayerStack.topAnchor, left: uiForPlayerStack.leftAnchor, right: nil, bottom: uiForPlayerStack.bottomAnchor, topPadding: 8, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        
        uiForPlayerStack.addSubview(playerStack)
        playerStack.Anchor(top: uiForPlayerStack.topAnchor, left: playerlabel.rightAnchor, right: uiForPlayerStack.rightAnchor, bottom: uiForPlayerStack.bottomAnchor, topPadding: 0, leftPadding: 20, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
//
        uiForAmountStack.Anchor(top: playerStack.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 50)
        uiForAmountStack.addSubview(amountStack)
        amountStack.Anchor(top: uiForAmountStack.topAnchor, left: uiForAmountStack.leftAnchor, right: uiForAmountStack.rightAnchor, bottom: uiForAmountStack.bottomAnchor, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
    }
    
    
}


