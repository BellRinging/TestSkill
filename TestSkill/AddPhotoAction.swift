//
//  AddPhotoAction.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 26/10/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import Foundation


extension AddPhotoController {
    
    func handleNext() {
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = selectedImage
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
