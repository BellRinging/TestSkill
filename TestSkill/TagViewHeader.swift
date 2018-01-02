import UIKit
import Firebase

class TagViewHeaderCell: UICollectionViewCell {
    
    
//    var tag : Tag? {
//        didSet{
//            guard let url = tag?.imageUrl else {return}
//            profileImage.loadImage(url)
//            guard let name = tag?.name else {return}
//            nameLabel.text = name
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    
    let profileImage : CustomImageView = {
        let im = CustomImageView()
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        im.image = #imageLiteral(resourceName: "empty-avatar")
        im.layer.cornerRadius = 80/2
        return im
    }()
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Chan Kenny"
        return label
    }()
    
    
    func setupView(){
        addSubview(profileImage)
        addSubview(nameLabel)
        
        profileImage.Anchor(top: topAnchor, left: nil, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 80, height: 80)
        
        profileImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        nameLabel.Anchor(top: profileImage.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)

        let dummy = UIView()
        dummy.backgroundColor = UIColor.gray
        addSubview(dummy)
        dummy.Anchor(top: nameLabel.bottomAnchor, left: nil, right: nil, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0.5)
        
    }
    
    
}



