//
//  Terms.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 29/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct ContactUsView: View {
    @Binding var closeFlag : Bool 
    
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment: .leading){
                    Text(" We dont have any support , but we welcome for any comment ")
                        .padding()
                    Text("Comment please send to my personal Email:")
                        .padding()
                        Text("kennyyeung.kw@gmail.com")
                        .padding()
                }
                .padding()
                Spacer()
            }
            .navigationBarTitle("Contact Us", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$closeFlag))
        }
    }
}

//struct Terms_Previews: PreviewProvider {
//    static var previews: some View {
//        Terms()
//    }
//}
