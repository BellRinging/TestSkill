import SwiftEntryKit
import SwiftUI
import FirebaseAuth

typealias Action = () -> ()


class Utility {
    
    static var currentNonce : String?
    static func getUserId() -> String {
        
        let actAsUser = UserDefaults.standard.retrieve(object: User.self, fromKey: UserDefaultsKey.ActAsUser)
        var uid = actAsUser == nil ? Auth.auth().currentUser!.uid:actAsUser!.id
        return uid
    }
    
    static func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
    static func showProgress(){

        DispatchQueue.main.async {
            guard let mainWindow = UIApplication.shared.window else {return}
            //tempView
            print("Show Progress")
            let vc = UIHostingController(rootView: ProgressView().background(Color.init(white: 0, opacity: 0.2)))
            let view = vc.view!
            let tempView = UIView(frame: (mainWindow.frame))
            tempView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            tempView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.centerXAnchor.constraint(equalTo: tempView.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: tempView.centerYAnchor).isActive = true
            tempView.tag = 999
            mainWindow.addSubview(tempView)
        }
    }
    
    static func hideProgress(){
        DispatchQueue.main.async {
            guard let mainWindow =  UIApplication.shared.window else {return}
            let view = mainWindow.viewWithTag(999)
            view?.removeFromSuperview()
        }
    }
    
   
    static func showAlert(message : String , callBack : (Action)?  = nil){
        print(message)
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
    
    static func getUserObject(id: String) -> User {
        let group = UserDefaults.standard.retrieve(object: [User].self, fromKey: UserDefaultsKey.CurrentGroupUser)!
        let index = group.firstIndex { $0.id == id }!
        return group[index]
    }
    
    static func getCurrentYear() -> Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    
    static func getPerviousYear() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date) - 1
        return year
    }
    
    static func getPYTM() -> String {
        let date = Date()
        var lastMonthDate = Calendar.current.date(byAdding: .year, value: -1, to: date)
        let format = DateFormatter()
        format.dateFormat = "yyyyMM"
        return format.string(from: date)
    }
    
    static func getLM() -> String {
        let date = Date()
        var lastMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: date)
        let format = DateFormatter()
        format.dateFormat = "yyyyMM"
        return format.string(from: lastMonthDate!)
    }
    static func getCM() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyyMM"
        return format.string(from: date)
    }
    
    
    
}
