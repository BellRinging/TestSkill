//
//  Helper.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 11/9/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import MBProgressHUD
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import SwiftEntryKit


class Utility {
    

    static func showProgress(){
        print("Show Progress")
        DispatchQueue.main.async {
      
            guard let mainWindow = UIApplication.shared.window else {return}
            let progressIcon = MBProgressHUD.showAdded(to: mainWindow, animated: true)
            progressIcon.labelText = "Loading"
            progressIcon.isUserInteractionEnabled = false
            //tempView
            
            let tempView = UIView(frame: (mainWindow.frame))
            tempView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            tempView.tag = 999
            mainWindow.addSubview(tempView)
            progressIcon.show(animated: true)
        }
    }
    
    static func hideProgress(){
        DispatchQueue.main.async {
            print("hide Progress")
            guard let mainWindow =  UIApplication.shared.window else {return}
            MBProgressHUD.hideAllHUDs(for: mainWindow, animated: true)
            let view = mainWindow.viewWithTag(999)
            view?.removeFromSuperview()
        }
    }
    
    
    static func showError(message : String){
           
           var attributes: EKAttributes
           var description: PresetDescription
           var descriptionString: String
           var descriptionThumb: String
           attributes = EKAttributes.centerFloat
           attributes.hapticFeedbackType = .success
           attributes.displayDuration = .infinity
           attributes.entryBackground = .gradient(
               gradient: .init(
                   colors: [EKColor(rgb: 0xfffbd5), EKColor(rgb: 0xb20a2c)],
                   startPoint: .zero,
                   endPoint: CGPoint(x: 1, y: 1)
               )
           )
           attributes.screenBackground = .color(color: .dimmedDarkBackground)
           attributes.shadow = .active(
               with: .init(
                   color: .black,
                   opacity: 0.3,
                   radius: 8
               )
           )
           attributes.screenInteraction = .dismiss
           attributes.entryInteraction = .absorbTouches
           attributes.scroll = .enabled(
               swipeable: true,
               pullbackAnimation: .jolt
           )
           attributes.roundCorners = .all(radius: 8)
           attributes.entranceAnimation = .init(
               translate: .init(
                   duration: 0.7,
                   spring: .init(damping: 0.7, initialVelocity: 0)
               ),
               scale: .init(
                   from: 0.7,
                   to: 1,
                   duration: 0.4,
                   spring: .init(damping: 1, initialVelocity: 0)
               )
           )
           attributes.exitAnimation = .init(
               translate: .init(duration: 0.2)
           )
           attributes.popBehavior = .animated(
               animation: .init(
                   translate: .init(duration: 0.35)
               )
           )
           attributes.positionConstraints.size = .init(
               width: .offset(value: 20),
               height: .intrinsic
           )
           attributes.positionConstraints.maxSize = .init(
               width: .constant(value: UIScreen.main.minEdge),
               height: .intrinsic
           )
           attributes.statusBar = .dark
           descriptionString = message
           descriptionThumb = ThumbDesc.bottomPopup.rawValue
           description = .init(
               with: attributes,
               title: "Pop Up II",
               description: descriptionString,
               thumb: descriptionThumb
           )
           let image = UIImage(named: "gear")!.withRenderingMode(.alwaysTemplate)
           let title = "Error"
           let description2 = message
           showPopupMessage(attributes: attributes,
                            title: title,
                            titleColor: .white,
                            description: description2,
                            descriptionColor: .white,
                            buttonTitleColor: ColorEK.Gray.mid,
                            buttonBackgroundColor: .white,
                            image: image)
           
       }
    
    static func showError(_ controller:UIViewController,message : String){
        
        var attributes: EKAttributes
        var description: PresetDescription
        var descriptionString: String
        var descriptionThumb: String
        attributes = EKAttributes.centerFloat
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.entryBackground = .gradient(
            gradient: .init(
                colors: [EKColor(rgb: 0xfffbd5), EKColor(rgb: 0xb20a2c)],
                startPoint: .zero,
                endPoint: CGPoint(x: 1, y: 1)
            )
        )
        attributes.screenBackground = .color(color: .dimmedDarkBackground)
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        attributes.roundCorners = .all(radius: 8)
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 0.7, initialVelocity: 0)
            ),
            scale: .init(
                from: 0.7,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.35)
            )
        )
        attributes.positionConstraints.size = .init(
            width: .offset(value: 20),
            height: .intrinsic
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.minEdge),
            height: .intrinsic
        )
        attributes.statusBar = .dark
        descriptionString = message
        descriptionThumb = ThumbDesc.bottomPopup.rawValue
        description = .init(
            with: attributes,
            title: "Pop Up II",
            description: descriptionString,
            thumb: descriptionThumb
        )
        let image = UIImage(named: "gear")!.withRenderingMode(.alwaysTemplate)
        let title = "Error"
        let description2 = message
        showPopupMessage(attributes: attributes,
                         title: title,
                         titleColor: .white,
                         description: description2,
                         descriptionColor: .white,
                         buttonTitleColor: ColorEK.Gray.mid,
                         buttonBackgroundColor: .white,
                         image: image)
        
    }
    
    static private func showPopupMessage(attributes: EKAttributes,
                                   title: String,
                                   titleColor: EKColor,
                                   description: String,
                                   descriptionColor: EKColor,
                                   buttonTitleColor: EKColor,
                                   buttonBackgroundColor: EKColor,
                                   image: UIImage? = nil) {
        
        var displayMode: EKAttributes.DisplayMode {
            return PresetsDataSource.displayMode
        }
        
         
         var themeImage: EKPopUpMessage.ThemeImage?
         if let image = image {
             themeImage = EKPopUpMessage.ThemeImage(
                 image: EKProperty.ImageContent(
                     image: image,
                     displayMode: displayMode,
                     size: CGSize(width: 60, height: 60),
                     tint: titleColor,
                     contentMode: .scaleAspectFit
                 )
             )
         }
         let title = EKProperty.LabelContent(
             text: title,
             style: .init(
                 font: MainFont.medium.with(size: 24),
                 color: titleColor,
                 alignment: .center,
                 displayMode: displayMode
             )
         )
         let description = EKProperty.LabelContent(
             text: description,
             style: .init(
                 font: MainFont.light.with(size: 16),
                 color: descriptionColor,
                 alignment: .center,
                 displayMode: displayMode
             )
         )
         let button = EKProperty.ButtonContent(
             label: .init(
                 text: "Got it!",
                 style: .init(
                     font: MainFont.bold.with(size: 16),
                     color: buttonTitleColor,
                     displayMode: displayMode
                 )
             ),
             backgroundColor: buttonBackgroundColor,
             highlightedBackgroundColor: buttonTitleColor.with(alpha: 0.05),
             displayMode: displayMode
         )
         let message = EKPopUpMessage(
             themeImage: themeImage,
             title: title,
             description: description,
             button: button) {
                 SwiftEntryKit.dismiss()
         }
         let contentView = EKPopUpMessageView(with: message)
         SwiftEntryKit.display(entry: contentView, using: attributes)
     }
    
    func logMessage(_ message: String,
                       fileName: String = #file,
                       functionName: String = #function,
                       lineNumber: Int = #line,
                       columnNumber: Int = #column) {
           
           print("### \(fileName) - \(message)")
    }
    
    private enum ThumbDesc: String {
        case bottomToast = "ic_bottom_toast"
        case bottomFloat = "ic_bottom_float"
        case topToast = "ic_top_toast"
        case topFloat = "ic_top_float"
        case statusBarNote = "ic_sb_note"
        case topNote = "ic_top_note"
        case bottomPopup = "ic_bottom_popup"
    }

}
