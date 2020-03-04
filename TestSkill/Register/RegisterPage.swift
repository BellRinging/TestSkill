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
    
     @Environment(\.presentationMode) var presentationMode
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var reEnterPassword : String = ""
    @State private var userName : String = ""
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = UIImage(named: "player3")
    @State private var image: Image? = Image("player3")
    
    var body: some View {
        NavigationView{
            VStack{
             
                image?
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .frame(width: 200 , height: 200)
                        .onTapGesture {
                            self.showingImagePicker = true
                        }
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage)
                }

                Form {
                    Section(header:
                        Text("Info")
                            .font(MainFont.forSmallTitleText()))
                    {
                        
                            TextField("Email Address", text: $email)
                        .autocapitalization(.none)
                            TextField("User name", text: $userName)
                        .autocapitalization(.none)
                            TextField("First name", text: $firstName)
                        .autocapitalization(.none)
                            TextField("Last name", text: $lastName)
                        .autocapitalization(.none)
                        
                    }
                    Section(header:
                        Text("Password")
                            .font(MainFont.forSmallTitleText())){
                                SecureField("Password", text: $password)
                                .autocapitalization(.none)
                                SecureField("Re-enter the password", text: $reEnterPassword)
                                .autocapitalization(.none)
                    }
                }
            }
            .navigationBarTitle("Fill in your info", displayMode: .inline)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = UIColor.red
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
            .navigationBarItems(leading: leftButton, trailing: rightButton)
        }
  
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    //    static let updateProfile = NSNotification.Name(rawValue: "UpdateProfile")
  
    
    var rightButton : some View{
        Button(action: {
             self.presentationMode.wrappedValue.dismiss()
        }, label:{
            Text("取消")
                .foregroundColor(SwiftUI.Color.white)
                .font(ChineseFont.regular.size(16))
        })
    }
    
    var leftButton : some View{
        Button(action: {
            self.handleRegister()
        }, label:{
            Text("確認")
                .foregroundColor(SwiftUI.Color.white)
                .font(ChineseFont.regular.size(16))
        })
    }
    
    var buttonArea : some View{
        HStack {
            RoundedRectangle(cornerRadius: 10) .fill(Color.greenColor)
                .overlay(         Button(action: {
                    
                }, label:{
                    Text("確認")
                        .foregroundColor(SwiftUI.Color.white)
                        .font(ChineseFont.regular.size(16))
                        .onTapGesture {
                            print("Register")
                            self.handleRegister()
                    }
                })
                    
            )
            RoundedRectangle(cornerRadius: 10) .fill(Color.redColor)
                .overlay(
                    Button(action: {
                    }, label:{
                        Text("取消")
                            .foregroundColor(SwiftUI.Color.white)
                            .font(ChineseFont.regular.size(16))
                    }))
        }
    }
    
    func handleRegister(){
        if !self.validField() {
            return
        }
        Utility.showProgress()
        print("Create login into firebase")
        createUserInDb().then { user in
            return RegisterHelper.uploadImage(uid: user.uid, inputImage: self.inputImage)
        }.then{ url in
            let providerUser = ProviderUser(userName: self.userName, firstName: self.firstName, lastName: self.lastName, email: self.email, imgUrl: url)
            RegisterHelper.registerUserIntoDatabase(providerUser)
            RegisterHelper.updateDisplayName(providerUser)
            print("Profile created")
            self.presentationMode.wrappedValue.dismiss()
        }.catch{ err in
            print("Fail to create login into firebase")
            Utility.showError(message: err.localizedDescription)
        }.always {
            Utility.hideProgress()
        }
        
    }
    
 
    
    func validField() -> Bool{
        if self.email == "" {
            Utility.showError(UIHostingController(rootView:self), message: "Email is required.Please enter your email")
            return false
        }
        if self.password == "" {
            Utility.showError(UIHostingController(rootView:self), message: "Password is required.Please enter your number")
            return false
        }
        if self.reEnterPassword == "" {
            Utility.showError(UIHostingController(rootView:self), message: "Password is required.Please enter your number")
            return false
        }
        
        if self.reEnterPassword != password {
            Utility.showError(UIHostingController(rootView:self), message: "Password is required.Please enter your number")
            return false
        }
        
        if self.userName == "" {
            Utility.showError(UIHostingController(rootView:self), message: "userName is required.Please enter your number")
            return false
        }
        if self.firstName == "" {
            Utility.showError(UIHostingController(rootView:self), message: "firstName is required.Please enter your number")
            return false
        }
        if self.lastName == "" {
            Utility.showError(UIHostingController(rootView:self), message: "lastName is required.Please enter your number")
            return false
        }
        return true
    }
    
    func createUserInDb() -> Promise<FirebaseAuth.User>  {
        let p = Promise<FirebaseAuth.User> { (resolve , reject) in
            Auth.auth().createUser(withEmail: self.email, password: self.password) { (result, err) in
                guard let user = result?.user else {
                    reject(err!)
                    return
                }
                resolve(user)
            }
        }
        return p
    }
    
  

    
   

}

struct RegisterPage_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPage()
    }
}

struct RegisterHelper{
    
    static func registerUserIntoDatabase(_ user:ProviderUser) {
        guard  let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let value = ["email": user.email ?? "",
                                        "id": uid,
                                        "userName":user.userName ?? "",
                                        "lastName": user.lastName ?? "",
                                        "firstName": user.firstName ?? "",
                                        "imgUrl": user.imgUrl ?? "",
                                        "balance":0
                               ] as [String : Any]
           let ref = Firestore.firestore()
           let usersReference = ref.collection("users").document(value["id"] as! String)
           usersReference.setData(value)
        
       }
    
    
    static func uploadImage(uid: String , inputImage : UIImage?) -> Promise<String> {
        let p = Promise<String> { (resolve , reject) in
            
            let ref = Storage.storage().reference().child("profile_images").child(uid).child("profilePic.jpg")
    
            if let  img = inputImage ,let uploadData = img.jpegData(compressionQuality: 0.1) {
                ref.putData(uploadData, metadata: nil) { (metaData, error) in
                    if let error = error{
                        reject(error)
                        return
                    }
                    ref.downloadURL { (url, err) in
                        if let err = err{
                            reject(err)
                            return
                        }
                        let profileImageURL = url!.absoluteString
                        resolve(profileImageURL)
                    }
                }
            }
        }
        return p
    }
    
    static func updateDisplayName(_ providerUser:ProviderUser) {
        guard let user = Auth.auth().currentUser else { return }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = providerUser.userName as! String
        changeRequest.photoURL = URL(fileURLWithPath: providerUser.imgUrl as! String)
        changeRequest.commitChanges(completion: { (error) in
            if let _ = error {
                return
            }
            print("Updated Display Name & Img Pic")
        })
      }
    
}




