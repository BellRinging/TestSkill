//
//  Extendsion.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Promises





struct UserDefaultsKey  {
    static let CurrentUser = "CurrentUser"
    static let  CurrentGroup = "CurrentGroup"
    static let  CurrentGroupUser = "CurrentGroupUser"
    static let  LoginFlag = "LoginFlag"
    static let  FcmToken = "FcmToken"
    static let  AppleIdUser = "AppleIdUser"
    
}




extension UserDefaults {

   func save<T:Encodable>(customObject object: T, inKey key: String) {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(object) {
           self.set(encoded, forKey: key)
       }
   }

   func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
       if let data = self.data(forKey: key) {
           let decoder = JSONDecoder()
           if let object = try? decoder.decode(type, from: data) {
               return object
           }else {
               print("Couldnt decode object for key : \(key)")
               return nil
           }
       }else {
           return nil
       }
   }

}


extension UIView{
    

    func Anchor(top : NSLayoutYAxisAnchor? = nil, left :  NSLayoutXAxisAnchor? = nil, right :  NSLayoutXAxisAnchor?  = nil, bottom :  NSLayoutYAxisAnchor? = nil,topPadding: CGFloat,leftPadding:CGFloat,rightPadding:CGFloat,bottomPadding:CGFloat, width : CGFloat = 0 ,height : CGFloat = 0){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            self.topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        if let left = left{
            self.leftAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
        }
        
        if let bottom = bottom{
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding).isActive = true
        }
        
        if let right = right{
            self.rightAnchor.constraint(equalTo: right, constant: -rightPadding).isActive = true
        }
        
        if (width != 0 ){
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if (height != 0 ){
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    
    func addGradientColor(colorFrom: UIColor ,colorTo:UIColor,startPosition : CGPoint = CGPoint.zero, endPosition : CGPoint = CGPoint(x: 1, y: 1)){
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [colorFrom.cgColor, colorTo.cgColor]
//        gradient.startPoint = CGPoint(x:0,y:1)
//        gradient.endPoint = CGPoint(x: 1, y: 0.4)
        gradient.startPoint = startPosition
        gradient.endPoint = endPosition
        
        
        if let abc = self as? UICollectionView {
            let tempView = UIView()
            tempView.layer.insertSublayer(gradient, at: 0)
            abc.backgroundView = tempView
        }else {
            self.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    func addDefaultGradient(){
        self.addGradientColor(colorFrom: UIColor.mainColor(), colorTo: UIColor.secondColor(), startPosition: CGPoint(x:0,y:1), endPosition: CGPoint(x:1,y:0.4))
    }
    
    
    func addBottomBorder(_ color : UIColor ,thickness: CGFloat){
        let borderView = UIView()
        self.addSubview(borderView)
        self.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = color
        borderView.Anchor(top: nil, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: thickness)
        
    }

    
}



extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
    
}




extension Notification.Name {
    static let updateGame = Notification.Name("updateGame")
    static let updateUserBalance = Notification.Name("updateUserBalance")
    static let updateLastGameRecord = Notification.Name("updateLastGameRecord")
    static let updateLastBig2GameRecord = Notification.Name("updateLastBig2GameRecord")
    static let addPlayGroup = Notification.Name("addPlayGroup")
    static let addFriend = Notification.Name("addFriend")
    static let updateUser = Notification.Name("updateUser")
    static let test = Notification.Name("test")
    static let dismissAddGameView = Notification.Name("dismissAddGameView")
    static let dismissMainView = Notification.Name("dismissMainView")
    static let dismissSwiftUI = Notification.Name("dismissSwiftUI")
    static let loginCompleted = Notification.Name("loginCompleted")
    static let dismissPlayGroup = Notification.Name("dismissPlayGroup")
    static let FCMToken = Notification.Name("FCMToken")
    
    static let flownGame = Notification.Name("flownGame")
    static let deleteGame = Notification.Name("deleteGame")
    

}


extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame {
                let statusBarView = UIView(frame: statusBarFrame)
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            } else if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            } else {
                return nil
            }
        }else{
            return nil
        }
    }
}
