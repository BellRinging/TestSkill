import MobileCoreServices

extension ChatLogController : UIImagePickerControllerDelegate {
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[.mediaType] as? String {
            if mediaType == "public.image" {
                handleImageSelectedForInfo(info as [UIImagePickerController.InfoKey : Any])
            }else{
                if let videoUrl = info[.mediaURL] as? URL {
                    handleVideoSelectedForUrl(videoUrl)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
}
