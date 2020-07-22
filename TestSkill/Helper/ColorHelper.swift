//
//  UIColor+Utils.swift
//  SwiftEntryKit
//
//  Created by Daniel Huri on 4/20/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit
import SwiftEntryKit
import SwiftUI

extension UIColor {
    
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

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    var ekColor: EKColor {
        return EKColor(self)
    }
    
    static let dimmedLightBackground = UIColor(white: 100.0/255.0, alpha: 0.3)
    static let dimmedDarkBackground = UIColor(white: 50.0/255.0, alpha: 0.3)
    static let dimmedDarkestBackground = UIColor(white: 0, alpha: 0.5)
    
    static let pinky = UIColor(rgb: 0xE91E63)
    static let amber = UIColor(rgb: 0xFFC107)
    static let satCyan = UIColor(rgb: 0x00BCD4)
    static let redish = UIColor(rgb: 0xFF5252)
    static let greenGrass = UIColor(rgb: 0x4CAF50)
    
    static let chatMessageLightMode = UIColor(red: 48, green: 47, blue: 48)
    static let chatMessageDarkMode = UIColor(red: 207, green: 208, blue: 207)
    
    static let textLightMode = UIColor(red: 33, green: 33, blue: 33)
    static let textDarkMode = UIColor(red: 222, green: 222, blue: 222)
    
    static let subTextLightMode = UIColor(red: 117, green: 117, blue: 117)
    static let subTextDarkMode = UIColor(red: 138, green: 138, blue: 138)
    
    static let musicBackgroundDark = UIColor(red: 36, green: 39, blue: 42)
    static let musicRedish = UIColor(red: 219, green: 58, blue: 94)

    static let lightNavigationBarBackground = UIColor(red: 251, green: 251, blue: 253)
    
    static let darkHeaderBackground = UIColor(red: 25, green: 26, blue: 25)
    
    static let darkSegmentedControl = UIColor(red: 55, green: 71, blue: 79)
}

extension SwiftUI.Color {
    static var grayColor: SwiftUI.Color {
        return SwiftUI.Color.init(red: 90/255, green: 90/255, blue: 90/255)
      }
    
    static var greenColor : SwiftUI.Color {
        return self.init(red: 6/255, green: 126/255, blue: 65/255)
    }
    
    static var redColor : SwiftUI.Color {
        return self.init(red: 225/255, green: 0/255, blue: 0/255)
    }
    
    static var textColor: SwiftUI.Color {
          return SwiftUI.Color.init(red: 29/255, green: 29/255, blue: 29/255)
        }
    static var navBarColor: SwiftUI.Color {
          return SwiftUI.Color.init(red: 225/255, green: 0/255, blue: 0/255)
        }
    
    static var whiteGaryColor: SwiftUI.Color {
      return SwiftUI.Color.init(red: 242/255, green: 243/255, blue: 244/255)
    }

//    func uiColor() -> UIColor {

//        let components = self.components()
//        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
//    }
    
   

    
}
//
//extension EKColor {
//
//    static var segmentedControlTint: EKColor {
//
//        return EKColor(.gray)
//
//    }
//
//    static var navigationItemColor: EKColor {
//        return EKColor(light: .gray,
//                       dark: .musicRedish)
//    }
//
//    static var navigationBackgroundColor: EKColor {
//        return EKColor(light: .lightNavigationBarBackground,
//                       dark: .black)
//    }
//
//    static var headerBackground: EKColor {
//        return EKColor(light: ColorEK.BlueGray.c50.with(alpha: 0.95).light,
//                       dark: .darkHeaderBackground)
//    }
//
//    static var headerText: EKColor {
//        return EKColor(.white).with(alpha: 0.95)
//    }
//
//    static var satCyan: EKColor {
//        return EKColor(.satCyan)
//    }
//
//    static var amber: EKColor {
//        return EKColor(.amber)
//    }
//
//    static var pinky: EKColor {
//        return EKColor(.pinky)
//    }
//
//    static var greenGrass: EKColor {
//        return EKColor(.greenGrass)
//    }
//
//    static var redish: EKColor {
//        return EKColor(.redish)
//    }
//
//    static var ratingStar: EKColor {
//        return EKColor(light: .amber,
//                       dark: .musicRedish)
//    }
//
//    static var musicBackground: EKColor {
//        return EKColor(light: .white,
//                       dark: .musicBackgroundDark)
//    }
//
//    static var musicText: EKColor {
//        return EKColor(light: .black,
//                       dark: .musicRedish)
//    }
//
//    static var selectedBackground: EKColor {
//        return EKColor(light: UIColor(white: 0.9, alpha: 1),
//                       dark: UIColor(white: 0.1, alpha: 1))
//    }
//
//    static var dimmedDarkBackground: EKColor {
//        return EKColor(light: .dimmedDarkBackground,
//                       dark: .dimmedDarkestBackground)
//    }
//
//    static var dimmedLightBackground: EKColor {
//        return EKColor(light: .dimmedLightBackground,
//                       dark: .dimmedDarkestBackground)
//    }
//
//    static var chatMessage: EKColor {
//        return EKColor(light: .chatMessageLightMode,
//                       dark: .chatMessageLightMode)
//    }
//
//    static var text: EKColor {
//        return EKColor(light: .textLightMode,
//                       dark: .textDarkMode)
//    }
//
//    static var subText: EKColor {
//        return EKColor(light: .subTextLightMode,
//                       dark: .subTextDarkMode)
//    }
//}

//struct ColorEK {
//    struct BlueGray {
//        static let c50 = EKColor(rgb: 0xeceff1)
//        static let c100 = EKColor(rgb: 0xcfd8dc)
//        static let c300 = EKColor(rgb: 0x90a4ae)
//        static let c400 = EKColor(rgb: 0x78909c)
//        static let c700 = EKColor(rgb: 0x455a64)
//        static let c800 = EKColor(rgb: 0x37474f)
//        static let c900 = EKColor(rgb: 0x263238)
//    }
//
//    struct Netflix {
//        static let light = EKColor(rgb: 0x485563)
//        static let dark = EKColor(rgb: 0x29323c)
//    }
//
//    struct Gray {
//        static let a800 = EKColor(rgb: 0x424242)
//        static let mid = EKColor(rgb: 0x616161)
//        static let light = EKColor(red: 230, green: 230, blue: 230)
//    }
//
//    struct Purple {
//        static let a300 = EKColor(rgb: 0xba68c8)
//        static let a400 = EKColor(rgb: 0xab47bc)
//        static let a700 = EKColor(rgb: 0xaa00ff)
//        static let deep = EKColor(rgb: 0x673ab7)
//    }
//
//    struct BlueGradient {
//        static let light = EKColor(red: 100, green: 172, blue: 196)
//        static let dark = EKColor(red: 27, green: 47, blue: 144)
//    }
//
//    struct Yellow {
//        static let a700 = EKColor(rgb: 0xffd600)
//    }
//
//    struct Teal {
//        static let a700 = EKColor(rgb: 0x00bfa5)
//        static let a600 = EKColor(rgb: 0x00897b)
//    }
//
//    struct Orange {
//        static let a50 = EKColor(rgb: 0xfff3e0)
//    }
//
//    struct LightBlue {
//        static let a700 = EKColor(rgb: 0x0091ea)
//    }
//
//    struct LightPink {
//        static let first = EKColor(rgb: 0xff9a9e)
//        static let last = EKColor(rgb: 0xfad0c4)
//    }
//}

