import Firebase
import AVFoundation

extension ChatLogController {
    

    
    func handleVideoSelectedForUrl(_ url: URL) {
        let filename = UUID().uuidString + ".mov"
        let ref = Storage.storage().reference().child("message_movies").child(filename);
        let uploadTask = ref.putFile(from: url, metadata: nil) { (metadata, error) in
            if error != nil {
                print("Failed upload of video:", error!)
                return
            }
            ref.downloadURL { (url, error) in
                ref.downloadURL { (url, error) in
                    if let videoUrl = url as? URL{
                        if let thumbnailImage = self.thumbnailImageForFileUrl(videoUrl) {
                            
                            self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
                                let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject]
                                self.sendMessageWithProperties(properties)
                                
                            })
                        }
                    }
                }
                

                }
            
        
            
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user?.user_name
        }
    }
    
    func handleImageSelectedForInfo(_ info: [UIImagePickerController.InfoKey : Any]) {
        
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(selectedImage, completion: { (imageUrl) in
                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
            })
        }
    }
    
    @objc func handleKeyboardDidShow() {
        scrollToLastItem()
    }
    @objc  
    func handleSend() {
        let properties = ["text": inputContainerView.inputTextField.text!]
        sendMessageWithProperties(properties as [String : AnyObject])
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
    
    func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
            
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    
    func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Failed to upload image:", error!)
                    return
                }
                ref.downloadURL { (url, error) in
                    if let videoUrl = url as? URL{
                        completion(videoUrl.absoluteString)
                    }
                }
            })
        }
    }
    
    
}
