import SwiftUI
import UIKit
import ALCameraViewController


struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var closeFlag: Bool
    
    
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, squarableCrop: true)
    }
    

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UINavigationController {
//        print("In Make")
//        print(self.closeFlag)
        let libraryViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { image, asset in
//            print(image)
//            print(asset)
            let abc = image?.copy() as? UIImage
            self.image = abc
            
                self.closeFlag = false
            
        }
        return libraryViewController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        print("In update: \(self.closeFlag)")
    }
    
}

