//
//  RegisterPage.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 2/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Promises
import GoogleSignIn
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


struct RegisterViewState {
    var email : String
    var password : String
}

enum RegisterViewInput {
    case normalLogin
    case googleLogin
    case facebookLogin
    case showRegisterPage
    case forgetPassword
}

struct RegisterPage: View {
    
   @ObservedObject var viewModel: RegisterViewModel
//    @ObservedObject var keyboardObserver = KeyboardObserver.shared
    
    init(closeFlag : Binding<Bool> , user : User? = nil){
        viewModel = RegisterViewModel(closeFlag: closeFlag , user : user)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                    self.viewModel.image?
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .frame(width: 200 , height: 200)
                    .onTapGesture {
                        withAnimation {
                            self.viewModel.hasSelectedPic = true
                            self.viewModel.showingImagePicker = true
                        }
                }
                Form {
                    Section(header:
                        Text("Info")
                            .font(MainFont.forSmallTitleText()))
                    {
                        
                        TextField("Email Address", text: self.$viewModel.email)
                            .autocapitalization(.none)
                            .disabled(self.viewModel.editMode)
                        TextField("User name", text: self.$viewModel.userName)
                            .autocapitalization(.none)
                        TextField("First name", text: self.$viewModel.firstName)
                            .autocapitalization(.none)
                        TextField("Last name", text: self.$viewModel.lastName)
                            .autocapitalization(.none)
                        
                    }
                    if !self.viewModel.editMode {
                        Section(header:
                            Text("Password")
                                .font(MainFont.forSmallTitleText())){
                                    SecureField("Password", text: self.$viewModel.password)
                                        .autocapitalization(.none)
                                    SecureField("Re-enter the password", text: self.$viewModel.reEnterPassword)
                                        .autocapitalization(.none)
                        }
                    }else{
                        Text("For password reset, please use the forget password under the login page").textStyle(size: 12)
                    }
                }
            }
            .keyboardResponsive()
            .navigationBarTitle("Register form", displayMode: .inline)
            .navigationBarItems(leading:  CancelButton(self.viewModel.$closeFlag), trailing: confirmButton)

        }.sheet(isPresented: self.$viewModel.showingImagePicker, onDismiss: {
            self.viewModel.loadImage()
        }, content: {
            ImagePicker(image: self.$viewModel.inputImage,closeFlag: self.$viewModel.showingImagePicker).accentColor(Color.redColor)
        })
    }
    
    
    
    var confirmButton : some View{
        Button(action: {
            self.viewModel.handleRegister()
        }, label:{
            Text("Confirm")
                .foregroundColor(Color.white)
        })
    }

}
