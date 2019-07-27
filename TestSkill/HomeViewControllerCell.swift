import UIKit


protocol HomePostCellDelegate {
    func didTapComment(post: Post)
    func didTapChat(user: User)
    func didLike(for cell: HomeViewControllerCell)
    func didTagImage(for cell: HomeViewControllerCell)
    func didShare(for cell: HomeViewControllerCell)
    func didTapOption(for cell: HomeViewControllerCell)
    func didTapTag(tag:Tag)
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
        
        addSubview(optionButton)
        optionButton.Anchor(top: topAnchor, left: nil, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 0, rightPadding: 8, bottomPadding: 0, width: 30, height: 30)

        addSubview(stackView)
        stackView.Anchor(top: nil, left: profileImage.rightAnchor, right: optionButton.leftAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
        stackView.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true

        addSubview(mainImage)
        mainImage.Anchor(top: profileImage.bottomAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: self.frame.width, height: self.frame.width)

        addSubview(likeButton)
        likeButton.Anchor(top: mainImage.bottomAnchor, left: leftAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 30, height: 30)

        addSubview(commentButton)
        commentButton.Anchor(top: mainImage.bottomAnchor, left: likeButton.rightAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 30, height: 30)

        addSubview(bookmarkButton)
        bookmarkButton.Anchor(top: mainImage.bottomAnchor, left: nil, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 0, rightPadding: 8, bottomPadding: 0, width: 30, height: 30)

        addSubview(shareButton)
        shareButton.Anchor(top: mainImage.bottomAnchor, left: commentButton.rightAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 30, height: 30)
        
        addSubview(chatButton)
        chatButton.Anchor(top: mainImage.bottomAnchor, left: shareButton.rightAnchor, right: nil, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 0, width: 30, height: 30)
        

        addSubview(likelabel)
        likelabel.Anchor(top: likeButton.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)

        
        addSubview(bottomlabel)

        bottomlabel.Anchor(top: likelabel.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 0)
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
//        lb.layer.borderColor = UIColor.blue.cgColor
//        lb.layer.borderWidth = 1
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        return lb
    }()
    
    lazy var bottomlabel : UITextViewFixed = {
        let lb = UITextViewFixed()
        lb.isUserInteractionEnabled = true
        lb.isEditable = false
        lb.isSelectable = false
        lb.isScrollEnabled = false
//        lb.numberOfLines = 0
//        lb.layer.borderWidth = 1
//        lb.layer.borderColor = UIColor.red.cgColor
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myMethodToHandleTap(_:))))
        return lb
    }()
    
    func didTagImage(){
        
    }
    
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post  else { return }
        let str = post.caption
        var resultString = NSMutableAttributedString(string: "\(post.user.name) ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
        
        let newLineSplitStr = str.split(separator: "\n", maxSplits: 500, omittingEmptySubsequences: false)
//        print(newLineSplitStr)
        var lineCount = 0
        for line in newLineSplitStr {
            lineCount = lineCount + 1
            
            let splitStr = line.split(separator: " ", maxSplits: 500, omittingEmptySubsequences: false)
            var itemCount = 0
            for aa in splitStr {
                itemCount = itemCount + 1
                let length = resultString.length
                let aalength = aa.count
                resultString.append(NSAttributedString(string: "\(aa)" , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
                if itemCount != splitStr.count{
                    resultString.append(NSAttributedString(string: " " , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
                }
                if aa.hasPrefix("#"){
                    let range =  NSRange(location: length, length: aalength)
                    resultString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
                    resultString.addAttribute(NSAttributedString.Key(rawValue: "Tag"), value: aa, range: range)
                }
            }
            if lineCount != newLineSplitStr.count{
                resultString.append(NSAttributedString(string: "\n" , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            }
            
        }
        
        
        
     
       
        bottomlabel.attributedText = resultString
        bottomlabel.sizeToFit()
        
    }
    
    
    
    lazy var commentButton : UIButton = {
        let bn = UIButton(type: .system)
        bn.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        bn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        bn.tintColor = UIColor.blue
        return bn
    }()
    
    lazy var chatButton : UIButton = {
        let bn = UIButton(type: .system)
        bn.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        bn.addTarget(self, action: #selector(handleChat), for: .touchUpInside)
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
    
    
    lazy var optionButton : UIButton = {
        let bn = UIButton(type: .system)
        bn.setImage(#imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), for: .normal)
        bn.addTarget(self, action: #selector(handleOption), for: .touchUpInside)
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
    
    @objc func handleOption(){
        delegate?.didTapOption(for: self)
    }
    
    @objc func handleLike(){
        delegate?.didLike(for: self)
    }
    
    @objc func handleComment(){
        delegate?.didTapComment(post: post!)
    }
    
    @objc func handleTagImage(){
        delegate?.didTagImage(for: self)
    }
    
    @objc func handleBookmark(){
        print("bookmark")
    }
    
    @objc func handleChat(){
        print("Chat")
        if let post = post {
            delegate?.didTapChat(user: post.user)
        }
    }
    
    @objc func handleShare(){
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
    
    func calculatTextHeigh(post : Post) -> CGFloat {
        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
        self.post = post
        let estimatedSize = bottomlabel.systemLayoutSizeFitting(targetSize)
        return bottomlabel.frame.height
    }
    
  
    @objc func myMethodToHandleTap(_ sender: UITapGestureRecognizer) {
        
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if characterIndex < myTextView.textStorage.length {
            
            let myRange = NSRange(location: characterIndex, length: 1)
            let substring = (myTextView.attributedText.string as NSString).substring(with: myRange)
//            print("character at index: \(substring)")
            
            // check if the tap location has a certain attribute
//            let attributeValue = myTextView.attributedText.attribute("Tag", at: characterIndex, effectiveRange: nil) as? String
//            if let value = attributeValue {
//                print("You tapped on Tag and the value is: \(value)")
//                let dict = ["name": value]
//                let tag = Tag(dict: dict)
//                delegate?.didTapTag(tag: tag)
//            }
        }
    }
    
}

