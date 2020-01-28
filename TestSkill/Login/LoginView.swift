//
//  LoginPageSwifUI.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 3/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import FBSDKLoginKit
import Promises
import Combine




struct LoginView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject var keyboardObserver = KeyboardObserver.shared
    private var tickets: [AnyCancellable] = []

    
    private mutating func addNotification(){
        NotificationCenter.default.publisher(for: .loginCompleted)
            .compactMap{$0.userInfo as NSDictionary?}
            .sink { (dict) in
                if let credential = dict["token"] as? AuthCredential , let tempUser = dict["user"] as? ProviderUser {
                    SocialLogin().firebaseLogin(credential, provider: "google",user:tempUser)
                }
        }.store(in: &tickets)
    }
    
    init(){
        viewModel = LoginViewModel()
        addNotification()

    }
    
    var body: some View {
        VStack {
           upperArea
           loginArea
           loginButton
            Text("----or-----")
                .font(MainFont.forPlaceHolder())
                .foregroundColor(Color.textColor)
            HStack{
                facebookButton
                googleButton
                Spacer()
            }.padding()
        }
        
    }
    
    var loginButton : some View{
        Button(action: {
            self.viewModel.normalLogin()
        }){
            HStack(alignment: .center) {
                Spacer()
                Text("Login")
                    .font(MainFont.forButtonText())
                    .foregroundColor(SwiftUI.Color.white).bold()
                Spacer()
            }.padding()
            
        }
        .background(SwiftUI.Color.greenColor)
            .padding()
            .shadow(radius: 5)
                     
    }
    
    var loginArea : some View{
        VStack{
            TextField("Email", text: $viewModel.email)
                .font(MainFont.forPlaceHolder())
                .padding()
                .cornerRadius(10)
                .background(SwiftUI.Color.whiteGaryColor)
            .autocapitalization(.none)

            SecureField("Password", text: $viewModel.password)
                .font(MainFont.forPlaceHolder())
                .padding()
                .cornerRadius(10)
                .background(SwiftUI.Color.whiteGaryColor)
            .autocapitalization(.none)
//
            HStack{
                Text("Register Account")
                    .font(MainFont.forPlaceHolder())
                    .foregroundColor(SwiftUI.Color.redColor)
                    .onTapGesture {
//                        self.viewModel
                    }
                    .sheet(isPresented: $viewModel.showRegisterPage) {
                                  RegisterPage()
                              }
                Spacer()
                Text("Forget Password")
                    .font(MainFont.forPlaceHolder())
                    .foregroundColor(SwiftUI.Color.redColor)
            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
    
    var upperArea : some View{
        VStack{
            
            PageView(viewModel.sampleDataForPageView)
                .aspectRatio(contentMode: ContentMode.fit)

            Text("Vietnam Majob")
                .foregroundColor(SwiftUI.Color.textColor)
                .font(MainFont.forTitleText())
            Text("少賭宜情 大賭李家誠")
//                .font(MainFont.bold.size(16))
            .titleStyle()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .foregroundColor(SwiftUI.Color.textColor)
        }
    }
    
    var googleButton : some View {
        Circle()
            .fill(SwiftUI.Color.init(red: 219/255, green: 68/255, blue: 55/255))
            .frame(width: 50, height: 50)
            .overlay(
                Image("icon-google")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .frame(width: 30, height: 30)
        ).shadow(radius: 5)
            .onTapGesture {
                SocialLogin().attemptLoginGoogle()
        }
    }
    
    var facebookButton : some View {
        Circle()
            .fill(SwiftUI.Color.init(red: 59/255, green: 89/255, blue: 152/255))
            .frame(width: 50, height: 50)
            .overlay(
                Image("icon-facebook")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .frame(width: 50, height: 50)
        ).shadow(radius: 5)
        .onTapGesture {
            SocialLogin().attemptLoginFb()
        }
    }
}


struct LoginPageSwifUI_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


