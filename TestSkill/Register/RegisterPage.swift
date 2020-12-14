//
//  RegisterPage.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 2/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct RegisterPage: View ,Equatable {
    
    static func == (lhs: RegisterPage, rhs: RegisterPage) -> Bool {
        return true
    }

   @ObservedObject var viewModel: RegisterViewModel
    
    init(closeFlag : Binding<Bool> , user : User? = nil , userType : String = "real"){
        print("init Register Page")
        viewModel = RegisterViewModel(closeFlag: closeFlag , user : user ,userType: userType)
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
                Text("")
                Form {
                    Section(header:
                        Text(self.viewModel.userType == "real" ? "Info" : "Dummy Account Info").textStyle(size: 16)
                    )
                    {
                        if self.viewModel.userType != "dummy"{
                            TextField("Email Address", text: self.$viewModel.email)
                                .autocapitalization(.none)
                                .disabled(self.viewModel.editMode)
                        }
                        TextField("User name", text: self.$viewModel.userName)
                            .autocapitalization(.none)
                        TextField("First name", text: self.$viewModel.firstName)
                            .autocapitalization(.none)
                        TextField("Last name", text: self.$viewModel.lastName)
                            .autocapitalization(.none)
                        if self.viewModel.userType == "dummy"{
                            TextField("Balance", text: self.$viewModel.balance)
                                .autocapitalization(.none)
                                .keyboardType(.numberPad)
                        }
                    }
                    if !self.viewModel.editMode && self.viewModel.userType == "real" {
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
                Spacer()
            }
//            .keyboardResponsive()
            .navigationBarTitle("\(self.viewModel.title)", displayMode: .inline)
            .navigationBarItems(leading:  CancelButton(self.viewModel.$closeFlag), trailing: ConfirmButton(){
                self.viewModel.handleRegister()
            })
        }.fullScreenCover(isPresented: self.$viewModel.showingImagePicker, onDismiss: self.viewModel.loadImage) {
            ImagePicker(image: self.$viewModel.inputImage,closeFlag: self.$viewModel.showingImagePicker)
        }
    }

}
