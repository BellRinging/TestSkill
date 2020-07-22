//
//  CustomAlertView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 30/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import SwiftEntryKit
import UIKit

struct UserDisplay: View {
    
    var size : Int
    var url : String
    var name : String
    
    init( url : String , name : String,size:Int = 40){
        self.size = size
        self.url = url
        self.name = name
    }
    init( user : User,size:Int = 40){
        self.size = size
        self.url = user.imgUrl
        self.name = user.userName
    }
    
    var body: some View {
        VStack{
            ImageView(withURL: url).ImageStyle(size: CGFloat(size))
            Text(name)
                .textStyle(size: 10)
                .frame(width: 60)
        }
        
    }
}
