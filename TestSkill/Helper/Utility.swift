import MBProgressHUD
import SwiftEntryKit
import SwiftUI
typealias Action = () -> ()
class Utility {
    
    static var currentNonce : String?
    
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
    
   
    static func showAlert(message : String , callBack : Action?  = nil){
           
        var alertView = CustomAlertView(message: message)
        if let callBack = callBack{
            alertView = CustomAlertView(message: message,callBack: callBack)
        }
        let customView = UIHostingController(rootView: alertView)
        var attributes = EKAttributes()
        attributes.windowLevel = .normal
        attributes.position = .center
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .forward
        attributes.entryInteraction = .forward
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.positionConstraints.size = .init(width: .offset(value: 50), height: .intrinsic)
        let edgeWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: edgeWidth), height: .intrinsic)
        attributes.roundCorners = .all(radius: 10)
        SwiftEntryKit.display(entry: customView, using: attributes)
    }
    
    static func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
}
