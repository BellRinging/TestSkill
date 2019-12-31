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

extension UIColor{
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    
    static func random() ->UIColor{
        let vR = CGFloat(arc4random() % 255)
        let vG = CGFloat(arc4random() % 255)
        let vB = CGFloat(arc4random() % 255)
        return UIColor.rgb(red: vR, green: vG, blue: vB)
    }
    
    static func mainColor() ->UIColor{
        return UIColor.rgb(red: 19, green: 106, blue: 138)
    }
    
    static func secondColor() ->UIColor{
        return UIColor.rgb(red: 38, green: 120, blue: 113)
    }
    
    static func textColor() ->UIColor{
        return UIColor.white
    }


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
               print("Couldnt decode object")
               return nil
           }
       }else {
           print("Couldnt find key")
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
/*
extension Promise {
    static var void: Promise<Void> {
        return Promise<Void>(())
    }
}
 */



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

//extension UserDefaults {
//        
//    func isLogin() -> Bool {
//        return 
//    }
//    
//    func logout() {
//        self.set(false, forKey: StaticValue.LOGINKEY)
//    }
//
//    func login() {
//        self.set(true, forKey: StaticValue.LOGINKEY)
//    }
//}



extension UIApplication {
    
    class var topViewController: UIViewController? {
        return getTopViewController()
    }
    
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension Equatable {
    func share() {
        let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        UIApplication.topViewController?.present(activity, animated: true, completion: nil)
    }
}
