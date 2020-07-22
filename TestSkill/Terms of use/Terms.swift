//
//  Terms.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 29/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct Terms: View {
    @Binding var closeFlag : Bool 
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    VStack(alignment: .leading){
                        Text(" 1. The app is current on beta version , new feature come in time to time")
                            .lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                            .padding()
                        Text(" 2. The app is created for internal usage,\n i am welcome to share among with these mahjong lover. But i wont have any support on any issue")
                            .lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                            .padding()
                        Text(" 3. App data is stored on our private cloud that may cause us money . So data may delete /housekeep without notified.")
                            .lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                            .padding()
                        Text(" 4. We dont respond for any data lost , please bear your own risk ")
                            .lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                            .padding()
                        Text(" 5. Again . There is no support and maintenance")
                            .padding()
                        Text("Warning :")
                            .textStyle(size: 20)
                            .padding()
                        
                        Text("You need to accept the term of use before you using this app ,otherwise please delete")
                            .lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                            .padding()
                    }
                    .padding()
                    Spacer()
                }
            }
            .navigationBarTitle("Terms of use", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$closeFlag))
        }
    }
}
