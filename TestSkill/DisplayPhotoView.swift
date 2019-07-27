//
//  DisplayPhotoView.swift
//  SnookerGambling
//
//  Created by Kwok Wai Yeung on 11/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit

class DisplayPhotoView: UIViewController {
    
    var imageUrl : String?{
        didSet{
            guard let url = imageUrl else {return}
            profileImage.loadImage(url)
        }
    }
    
    
    let profileImage : CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
//        imageView.image = #imageLiteral(resourceName: "default-image")
        return imageView
    }()
    
    
    lazy var cancelButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "cancel_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside )
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        setupViewlayout()
    }
    
    func setupViewlayout(){
        view.addSubview(profileImage)
        view.addSubview(cancelButton)
        
        profileImage.Anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        cancelButton.Anchor(top: view.topAnchor, left: nil, right: view.rightAnchor, bottom: nil, topPadding: 20, leftPadding: 0, rightPadding: 20, bottomPadding: 0, width: 40, height: 40)
    }
    
    
}

