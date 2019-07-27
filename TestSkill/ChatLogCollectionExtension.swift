import Firebase

extension ChatLogController  {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.chatLogController = self
        let message = messages[indexPath.item]
        
        cell.message = message
        cell.textView.text = message.text
        setupCell(cell, message: message)
        
        if let text = message.text {
            //a text message
            cell.bubbleWidthAnchor?.isActive = false
            let width = estimateFrameForText(text).width + 32
            cell.bubbleWidthAnchor?.constant = width
            cell.bubbleWidthAnchor?.isActive = true
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            //fall in here if its an image message
             cell.bubbleWidthAnchor?.isActive = false
            cell.bubbleWidthAnchor?.constant = 200
             cell.bubbleWidthAnchor?.isActive = true
            cell.textView.isHidden = true
        }
        
        cell.playButton.isHidden = message.videoUrl == nil
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            
            // h1 / w1 = h2 / w2
            // solve for h1
            // h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWidth * 200)
            
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    fileprivate func setupCell(_ cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.imageUrl {
            cell.profileImageView.loadImage(profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        } else {
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImage(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        return estFrame
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
}
